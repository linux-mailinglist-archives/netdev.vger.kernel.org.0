Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BCE15EAB2
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 19:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbfGCRmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 13:42:55 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34706 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCRmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 13:42:55 -0400
Received: by mail-qk1-f195.google.com with SMTP id t8so3492332qkt.1
        for <netdev@vger.kernel.org>; Wed, 03 Jul 2019 10:42:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=9aZmH+Pg7dlHICbo2t+3qKmRAkyWEbku6oFpnfKvKao=;
        b=WH9HHfJk52kzOOibbgRfRkij7cs0Pi+rOYg4utplJBcJAtNYCP00f26DistQeaElS0
         OOgPVoqUXidFgsWcM4UCe/xScx8cAD/uWsTBnt3wIezwKcEA4K4wPabJjhhvobY0fjSh
         qvWpl1JO1Tv5GjiodYThyQBw1bhqulF4KlJMzZt8VXFCIDziYZzrkWjt1yhdBx49a8Ge
         Kl1f3qg8yO5a6GsFiZ8kQN1AyeMFoJn9vcB+PHs4/3dd3BlNFU3+/86J0py7Nc3bX5MU
         uP4fpRaX4hbQULiFEvkYeyNtxOTjoBlm5Q++iL1oQSQy7rv5VfqmekLJr6TrpJhlxVlV
         CB0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=9aZmH+Pg7dlHICbo2t+3qKmRAkyWEbku6oFpnfKvKao=;
        b=GBTzAQbwRYUM7XrqWatC0Djuqz6v6X2CX2bTOeyFmVr/RoldMuMJ8wm0lfUKvIIOGs
         AIyhUFRFu77g4rvdsR4JuRoU2MkzfFHvy3r7LMplkfhbyVXH0kZh6hFTgeQg2ckthno9
         OSr/0YB1VCPCI5ZDEXzjcrtxPMJykX6CNy7/tRqy5LmOtn3GZnXR0Lswir6dYnI6I9yW
         LglVS1IqF7Urr5TmGV2T1020pZl64fWiTumr5WvsBK+LhRZujsuBTRBKIrRcLZLWeZ0+
         8QsTEj8/CJtHMaXYfk92Ha8wsBk1uF4apz/kUFKDndIA/raDEH1U4ne3cxPNA/mHBnpM
         iB2g==
X-Gm-Message-State: APjAAAUtr0IPSnlXvO3Ryc3eR2wMrFLsE8vra0FRgWG3K3en5+Zb8McQ
        7vJhWvlo6oCvot+zf09vhbW9HQ==
X-Google-Smtp-Source: APXvYqx0N/ArL09FpIHbw3Mrm9q1Z8Hl4jAzzJQuhCOa1hvGbPVyBJQjwVfmcO/twh6DMlbjOXT6DA==
X-Received: by 2002:a37:4243:: with SMTP id p64mr32137574qka.9.1562175774109;
        Wed, 03 Jul 2019 10:42:54 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q9sm1184643qkm.63.2019.07.03.10.42.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 03 Jul 2019 10:42:53 -0700 (PDT)
Date:   Wed, 3 Jul 2019 10:42:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Sudarsana Reddy Kalluru <skalluru@marvell.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Ariel Elior" <aelior@marvell.com>
Subject: Re: [EXT] Re: [PATCH net-next 4/4] qed: Add devlink support for
 configuration attributes.
Message-ID: <20190703104244.7d26e734@cakuba.netronome.com>
In-Reply-To: <MN2PR18MB2528065BE3D46045F7EA1888D3FB0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <20190617114528.17086-1-skalluru@marvell.com>
        <20190617114528.17086-5-skalluru@marvell.com>
        <20190617155411.53cf07cf@cakuba.netronome.com>
        <MN2PR18MB25289FE6D99432939990C979D3E40@MN2PR18MB2528.namprd18.prod.outlook.com>
        <20190620133748.GD2504@nanopsycho>
        <MN2PR18MB2528065BE3D46045F7EA1888D3FB0@MN2PR18MB2528.namprd18.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Jul 2019 12:56:39 +0000, Sudarsana Reddy Kalluru wrote:
> Apologies for bringing this topic again. From the driver(s) code
> paths/'devlink man pages', I understood that devlink-port object is
> an entity on top of the PCI bus device. Some drivers say NFP
> represents vnics (on pci-dev) as a devlink-ports and, some represents
> (virtual?) ports on the PF/device as devlink-ports. In the case of
> Marvell NIC driver, we don't have [port] partitioning of the PCI
> device. And the config attributes are specific to PCI-device (not the
> vports/vnics of PF). Hence I didn't see a need for creating
> devlink-port objects in the system for Marvell NICs. And planning to
> add the config attributes to 'devlink-dev' object. Please let me know
> if my understanding and the proposal is ok?

I understand where you're coming from.  

We want to make that judgement call on attribute-by-attribute basis.  
We want consistency across vendors (and, frankly, multiple drivers of
the same vendor).  If attribute looks like it belongs to the port,
rather than the entire device/ASIC operation, we should make it a port
attribute.
