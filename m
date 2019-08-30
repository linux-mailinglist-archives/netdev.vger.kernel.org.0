Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04370A3CE2
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 19:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbfH3RUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 13:20:19 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39148 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfH3RUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 13:20:18 -0400
Received: by mail-qt1-f193.google.com with SMTP id n7so8389387qtb.6
        for <netdev@vger.kernel.org>; Fri, 30 Aug 2019 10:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:message-id:from:to:cc:subject:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=HqYjUFkMHJRt0423B9PPCGjkyABvf/YxS1nZLH4SrgA=;
        b=A6jxGLKugYwM0p5LoXi2Iw1E7kXz3ztc7X0ngCBvIQrEXNCycNAn41q8zxzZHEXvz/
         1nrSxap7Ft2HS38DwMtkfCSrBDwZVEJWKIPxLD/vdPADay84S9MmO9kIvmCuprrSfAEs
         ZfZFbIFoHgtnc/0iaJQYrECmvQnCEDoqNevXbVAjDzG/sznnyVmqxq92b0Rx1Z/aeYyJ
         E89TXTuVaqKEWk8x92C/3r8d82o/POvKF+n5IGuWTpmJPHE9IdsWcg3WPKE3780uLQBP
         ThUt5w91QlkGlc8YttXIHZ+k0k8XM4KafcDgxqic1in7ZAz0QZJ+KGxj05+yUpDKmWet
         GW0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:from:to:cc:subject:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=HqYjUFkMHJRt0423B9PPCGjkyABvf/YxS1nZLH4SrgA=;
        b=slDTcsf8JtthM5PKx0CCSSwOt703haoM+65BskIAPAvY1En16gfOWd/Yq8cEFkXCt/
         J1EcpVJu7jJvXJXOCSxI0gkz2nVcdHiZJCf6KwzPmpM/yrwhUJlrlSSiSyXqKdUJpzCr
         n9K1T56OCxCek9AhwvM1VLd42OIA2bWYlDsXWUrYotb5GujWTLvtRTMAiRolD7uos9K3
         KOn62X/DZnhOHlR0GbY6AV+IoMghY+jamYn3itPnafVxPXvZp7qRzfXL7yOWfkEagbJs
         wjSKb5Wayrrdh2SamCOFVt3ppOxQHImawh4CHI5PyftisrDI86MghCiYSzcBVDipqR9K
         cqvQ==
X-Gm-Message-State: APjAAAVd3JDmz7hi6N1XPg7l7VjFQa8+cnQhbiUCEu65vC3qD/D7BF54
        Tc+ub0ZP183ShQDtEbnZ900=
X-Google-Smtp-Source: APXvYqy6M8dIRVT/NMUg/VsdrEiNQpYY2LSsovY1ZiwuxXKCEDQNVUi4DPwWlHAcUjUN8hxAFwRxxQ==
X-Received: by 2002:ac8:65d4:: with SMTP id t20mr16672784qto.249.1567185617863;
        Fri, 30 Aug 2019 10:20:17 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id b192sm2566736qkg.39.2019.08.30.10.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 10:20:16 -0700 (PDT)
Date:   Fri, 30 Aug 2019 13:20:15 -0400
Message-ID: <20190830132015.GC19349@t480s.localdomain>
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, andrew@lunn.ch, idosch@idosch.org,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v3 net-next 2/2] net: dsa: tag_8021q: Restore bridge VLANs
 when enabling vlan_filtering
In-Reply-To: <20190830005325.26526-3-olteanv@gmail.com>
References: <20190830005325.26526-1-olteanv@gmail.com>
 <20190830005325.26526-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On Fri, 30 Aug 2019 03:53:25 +0300, Vladimir Oltean <olteanv@gmail.com> wrote:
> The bridge core assumes that enabling/disabling vlan_filtering will
> translate into the simple toggling of a flag for switchdev drivers.
> 
> That is clearly not the case for sja1105, which alters the VLAN table
> and the pvids in order to obtain port separation in standalone mode.
> 
> There are 2 parts to the issue.
> 
> First, tag_8021q changes the pvid to a unique per-port rx_vid for frame
> identification. But we need to disable tag_8021q when vlan_filtering
> kicks in, and at that point, the VLAN configured as pvid will have to be
> removed from the filtering table of the ports. With an invalid pvid, the
> ports will drop all traffic.  Since the bridge will not call any vlan
> operation through switchdev after enabling vlan_filtering, we need to
> ensure we're in a functional state ourselves. Hence read the pvid that
> the bridge is aware of, and program that into our ports.
> 
> Secondly, tag_8021q uses the 1024-3071 range privately in
> vlan_filtering=0 mode. Had the user installed one of these VLANs during
> a previous vlan_filtering=1 session, then upon the next tag_8021q
> cleanup for vlan_filtering to kick in again, VLANs in that range will
> get deleted unconditionally, hence breaking user expectation. So when
> deleting the VLANs, check if the bridge had knowledge about them, and if
> it did, re-apply the settings. Wrap this logic inside a
> dsa_8021q_vid_apply helper function to reduce code duplication.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

I have no complaint with this series:

Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>


Thanks for sending smaller pieces like this one btw,

	Vivien
