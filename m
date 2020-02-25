Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4A2016E9F6
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 16:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731069AbgBYPY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 10:24:27 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:47023 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbgBYPY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 10:24:27 -0500
Received: by mail-qk1-f194.google.com with SMTP id u124so12189756qkh.13;
        Tue, 25 Feb 2020 07:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=6Ncg/IKMaDZiOMqupX+S+PJTsB+ocvBSJPg8Zaspt8Y=;
        b=OHutEhIbBOf73FwZZBukrieOB/TkrRrVUvg3XqQn5i4sNkq7hKQ4NE0a1xdknz6s05
         fVwFGjvW5npCHe279/i9KXyND6QMWgbZwygrSSIY8Zn/TQeg/1b1bb0EsdnvkYlv6C6B
         /3YEAyRl9lRWP1IEtFET+T11/13JTOXIKshoN9FXzXpc1Di4NBPDd7uV8js+XJZ6MTuF
         XUUdkSgoM9J+dCU4cSKvoxaFOWpZ3G/4QfYN9XO87oROeXOQWXtz2DSIwrMgSkVdXiWG
         na2O4AKiC7QGTbcYTYjRbxGbkQr5JHQL8Edd/DU5ykmi/TPvnKGKt1d/y9QAcQEJcCz5
         AjYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=6Ncg/IKMaDZiOMqupX+S+PJTsB+ocvBSJPg8Zaspt8Y=;
        b=jSVtVfk0FxR8NNshJIzgiaK3SHrZXojvLFggTNwqjQElhFl+1xGqumE5VCs4C1r1IX
         wEuWH4AxaPqLUu3gtEWSwrrZOVIGCeS+h/KyjvPLOTUFnlgipPJDHKjJ73HCbkC2uRAR
         HQVByzT2YdpgoWrD1OmyD4P9y8tKaOOOSI5uyfySPPCL7JPvq8Fiz592WYwS68GDltHt
         WEhGTk6NaoFNZXWaW3uvEPmaRvlXrqAf9zuMK6zQzbv3fWFRJtKKaMyBDortrH8v0EAR
         ujZdj/QVJiap3JPv7l3ncE5Nq6k2TuMmd+bPcNMu9nwb7UnLuxsvOipYDKW2notryy2u
         FpWw==
X-Gm-Message-State: APjAAAU+lVc9+qyO7tlJ1xnJzaMCvGoDxg8bkNTUcKnWkDuUwl3XVHMB
        8pqbbizbnGaeGy0NFA75sPk=
X-Google-Smtp-Source: APXvYqyQIwtfbtN6oSef2kPh4lRCxbB51UlGRbO8Yz46uatDz2X7BxpxW0T6+huFpyQSqlCoXf4+bg==
X-Received: by 2002:a05:620a:1650:: with SMTP id c16mr58589893qko.346.1582644266026;
        Tue, 25 Feb 2020 07:24:26 -0800 (PST)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id d9sm7526626qth.34.2020.02.25.07.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 07:24:25 -0800 (PST)
Date:   Tue, 25 Feb 2020 10:24:24 -0500
Message-ID: <20200225102424.GB5199@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: dsa: bcm_sf2: Forcibly configure IMP port for
 1Gb/sec
In-Reply-To: <20200224235632.5163-1-f.fainelli@gmail.com>
References: <20200224235632.5163-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 15:56:32 -0800, Florian Fainelli <f.fainelli@gmail.com> wrote:
> We are still experiencing some packet loss with the existing advanced
> congestion buffering (ACB) settings with the IMP port configured for
> 2Gb/sec, so revert to conservative link speeds that do not produce
> packet loss until this is resolved.
> 
> Fixes: 8f1880cbe8d0 ("net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec")
> Fixes: de34d7084edd ("net: dsa: bcm_sf2: Only 7278 supports 2Gb/sec IMP port")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
