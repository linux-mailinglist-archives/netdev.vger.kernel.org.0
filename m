Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3442A6175B
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 21:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfGGTuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 15:50:18 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:38794 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727438AbfGGTuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 15:50:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id g17so4624795wrr.5
        for <netdev@vger.kernel.org>; Sun, 07 Jul 2019 12:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sTKiWxtvihHAGqMWK1L8Ly16evb/n0hip/8dJkZkZR0=;
        b=X1IRsLF6HS4HkcseMO7zMXwiFMuPzcotNRIGySrX7TunNsgY3XUX3rn+F+Cqux54TF
         Ba/AXMc8GNx8wEs5ucSM8WNgDVqtnGrbWJhmRRuNLPwsBxd1AviiQffQvdtBq8fF1b+g
         mWrM+qkkI0VoVa56c472thEbrt/FU+nezw3cRH9qXEE/t5Zt2+3CcTS0/Sor+H6ZvM2P
         /kue8LwJM2azyGG57DUjeey2vMf79u4w0AQrVJa+b/o3e2djJnBFHCk0cVgwKbZu4AOX
         DdHFEnYZRhWFNr9ovIzhTGZ4JUOAREWG8kgQBlDxs9w/p856ho2C/6SeQ6lLUPK7ITZk
         y6CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=sTKiWxtvihHAGqMWK1L8Ly16evb/n0hip/8dJkZkZR0=;
        b=ZHyDW3gW9cicwMO6ZslrOX0WUE6cN7RFTE2bTDkfh+n5TJav6wJh/biDbUAsmxHltD
         v/htSPyfb/BJTCecb3l5Z/PzBQyBgLw/L+jgZ4l4ujDObjxO2CNv8HtY9IwEXHVCxnSb
         exk9ANg/slRJitpNoZtfIsdNSwGwSnks2++3tNi8YprDdfYJSbOykjgXFHo4oqItRYai
         qZAJ+sqx7c2/4DfEBtFeBdAFpABiMBvUNHjrjRakG0+Ab2za71zZlRjk9vT4bspggYyC
         y90bq1A07QktRW7ouMEyg15Id3XW7b66UI0aX07QjywhK05p2tpnmsvlOGzQnVEKsuKA
         jgCA==
X-Gm-Message-State: APjAAAWLdSO8D2bVOY4U28yxy7BxNcpKXCaUln8hh52mNv8ErJTTgcnz
        /5XfmaAKLoAK9uFMiEEH+8R8kg==
X-Google-Smtp-Source: APXvYqz3/8MEGUwofv1K+k3BKc/S4hnX9TiDj4yoxRfjfQhXU6dU9FWORUYLlkmaaSP69ukhS03SBg==
X-Received: by 2002:a5d:6783:: with SMTP id v3mr14498552wru.318.1562529016311;
        Sun, 07 Jul 2019 12:50:16 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id 72sm14138580wrk.22.2019.07.07.12.50.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 07 Jul 2019 12:50:15 -0700 (PDT)
Date:   Sun, 7 Jul 2019 21:50:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com,
        jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next v4 2/4] devlink: Introduce PCI PF port flavour
 and port attribute
Message-ID: <20190707195015.GB2306@nanopsycho.orion>
References: <20190701122734.18770-1-parav@mellanox.com>
 <20190706182350.11929-1-parav@mellanox.com>
 <20190706182350.11929-3-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190706182350.11929-3-parav@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Jul 06, 2019 at 08:23:48PM CEST, parav@mellanox.com wrote:
>In an eswitch, PCI PF may have port which is normally represented
>using a representor netdevice.
>To have better visibility of eswitch port, its association with
>PF and a representor netdevice, introduce a PCI PF port
>flavour and port attriute.
>
>When devlink port flavour is PCI PF, fill up PCI PF attributes of the
>port.
>
>Extend port name creation using PCI PF number on best effort basis.
>So that vendor drivers can skip defining their own scheme.
>
>$ devlink port show
>pci/0000:05:00.0/0: type eth netdev eth0 flavour pcipf pfnum 0
>
>Signed-off-by: Parav Pandit <parav@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
