Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0269B18FCAE
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 19:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbgCWS2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 14:28:03 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35132 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbgCWS2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 14:28:03 -0400
Received: by mail-qk1-f196.google.com with SMTP id k13so4663157qki.2;
        Mon, 23 Mar 2020 11:28:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=3wB0xVpulcp40RTW3vhxAgoqjUdCApY2I0xSALST5l8=;
        b=iWId/kub+Jrlo1bcvpBVEXxR/ZG9PWIncegc9idzjaRroBA4JrJJ7Y70UOECdbDiXd
         B3BoZpqvZqkcN/ptpNHuT5/3TLthAFgGaho6+/ig0Vfx7Qs5qQCOc4Ho8Pb9lN1nauQt
         kgk4+kYQNe4WhXNz8IrpJnBIpyqJ8XUKKreavbZIChnXotm1ncu8tKQq0WMIhb5sG7qq
         UHK83Nbfhdv5+rJRg0rHUhDc+PS/H0vu0HNYlKTWumJKnBJWdy0LnSBXfbLkPhg4gx31
         qZtjm9LrumSQNjIEWpF8rDb4W9R00pSh1/m5cEKdlG46L5RzvhSyCjwVW6jw7vsUqqvX
         7Iuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=3wB0xVpulcp40RTW3vhxAgoqjUdCApY2I0xSALST5l8=;
        b=NtAXmLPvHbbhhIhhigxj9UHO3JhHTDe9ek9VRZFZps6wqsceOnnkJRlNVqVh4JSRfc
         eY4VSVMxSCzHFk7hPsk61Vch2aZCvpMG8lqtVgOBSDOfYwUIR6/0Vg5wWAouURICOcWO
         IpJq4l+7s0VtgpR0OGmAImhX6gPrDYCxdz63OtDBwd/rLjDCm4FyNx7HH1o6A97EvToL
         iTr23bYLR5DmCgTi4Na2g/DJzIEvGNZCjkEIqjS1Lhgu43ap4BgXw8JMAPXRTVMt3VJ4
         /fx6bp7WU9Qw/liVhms9QGCVO/qHmhDYPYThKAARRL7qGC4/PrGoEfE/jEOmkjbkjz+W
         eERA==
X-Gm-Message-State: ANhLgQ0DZx04FuOhSniPOxzfCYUbIPzHF0hEKXKyZsFtXRtybAWVskMc
        rG4ROSZFlPqMWP8mb6rewd4=
X-Google-Smtp-Source: ADFU+vthjZL644J49K7lhCku/51veVNw3keoxJgU51g8G/2TuPtgYFtuz1OgXoV5uQVkESY/vVx3BQ==
X-Received: by 2002:a37:8d81:: with SMTP id p123mr9768397qkd.17.1584988082030;
        Mon, 23 Mar 2020 11:28:02 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id n4sm12146258qti.55.2020.03.23.11.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 11:28:01 -0700 (PDT)
Date:   Mon, 23 Mar 2020 14:28:00 -0400
Message-ID: <20200323142800.GD4041079@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, alobakin@dlink.ru, olteanv@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: dsa: Implement flow dissection for
 tag_brcm.c
In-Reply-To: <20200322210957.3940-1-f.fainelli@gmail.com>
References: <20200322210957.3940-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Mar 2020 14:09:57 -0700, Florian Fainelli <f.fainelli@gmail.com> wrote:
> Provide a flow_dissect callback which returns the network offset and
> where to find the skb protocol, given the tags structure a common
> function works for both tagging formats that are supported.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
