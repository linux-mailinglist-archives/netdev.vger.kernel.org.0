Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67797446F1
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393067AbfFMQzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:55:37 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34154 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729986AbfFMB4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 21:56:47 -0400
Received: by mail-qt1-f195.google.com with SMTP id m29so20804075qtu.1
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 18:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=1JpltMjdf+HSwEhY9B0lNZwBJ01nmnlcIIN4Pm81l+M=;
        b=TkZyPk2f2b/gK1FgROx0TsaAgu3YQ6G+YsZpeeo9gDc2zR+4kVrtyvc/eBeolIx5Zb
         rRsqeXr3fXqUMkOBDldhMozvDnjhtGsnYFovPL6usa2v/S/lmB5Ch/JDwOVZhuna4UAF
         jdNFfNCh02IwNMaaiZyXjB/ArIjtdVNsleOPPMbuvgq607iDO2/BD5XWhWLfrP5YzvTm
         eU1pFS9iJtw6PcLAdtoei2h1GIh3cs8GYECaq0Q6/2816ctIdiBQ6YAYQ8QqKTywNOKs
         bBSgvAKaQlcY/E5A3W/BijjNYUEIfirc8c+YeCZj/dvWeyIBVz99K1N9aGYxnUHgdQnQ
         g0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=1JpltMjdf+HSwEhY9B0lNZwBJ01nmnlcIIN4Pm81l+M=;
        b=hboMbjbO5NycEpyodC0Oc6LSbl8ziHj/7JpWhQPlMN5hzDm4gk6kwljdHOPnLgGB9m
         YNxNf0g4WVx3koPBBIH3v6B259xUtzB3ePOIpFbofQ9iXONxt9xtGdPf+y1BNXhfgC31
         Yhe35h73g6XNPkC//u8Ua11VN2fTkMYTYHN829QlHf9yn0iZm+fqpS9+8h9h0N5rz1iv
         TlOkGgiIsbq+5TLCahDa0mpYNDxw2j3BT+Xqw8QPesHo5qkHETB2uAFxl5OrseaqLzTu
         EZMpmtddplt7Nsck8OswovxglF89p11AM5MNafAhdYfglUpbtfdZ+JbGDVHtQsIZsL68
         Z0/Q==
X-Gm-Message-State: APjAAAUaeQunQakbQmOoRf6hF/zbWmO4nz0Ro50ZQ0V7oDDst2HjlBeD
        K+PtR7dAquPi+1zP7BKISEaUt6I6dQM=
X-Google-Smtp-Source: APXvYqzx6QLZQXfnSlPNcd881M2ZLICsWbl9xM31ET0iDVyyRZ1b3A5hnG46KDO6ckZkfEECkVtAfQ==
X-Received: by 2002:a0c:b0c6:: with SMTP id p6mr1280474qvc.225.1560391006843;
        Wed, 12 Jun 2019 18:56:46 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id u4sm690103qkb.16.2019.06.12.18.56.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 12 Jun 2019 18:56:46 -0700 (PDT)
Date:   Wed, 12 Jun 2019 21:56:44 -0400
Message-ID: <20190612215644.GB32026@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: do not flood CPU with
 unknown multicast
In-Reply-To: <20190612232552.pzsp5rdadlaiht2n@shell.armlinux.org.uk>
References: <20190612223344.28781-1-vivien.didelot@gmail.com>
 <20190612232552.pzsp5rdadlaiht2n@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On Thu, 13 Jun 2019 00:25:52 +0100, Russell King - ARM Linux admin <linux@armlinux.org.uk> wrote:
> On Wed, Jun 12, 2019 at 06:33:44PM -0400, Vivien Didelot wrote:
> > The DSA ports must flood unknown unicast and multicast, but the switch
> > must not flood the CPU ports with unknown multicast, as this results
> > in a lot of undesirable traffic that the network stack needs to filter
> > in software.
> 
> What if you have configured IPv6 on the bridge device, and are expecting
> the multicasted IPv6 frames for neighbour discovery to work?

Multicast management should still be flooded, so I would expect this
to work? Can you describe the test you want me to run for this case?


Thanks,
Vivien
