Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86FEA4E3A18
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiCVIJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiCVIJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:09:26 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5371F13F95
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 01:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647936478; x=1679472478;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zYQNtD+FBltv2TyYR5BxkKM7xxtd3n+XRFRV/2e34vQ=;
  b=SwhBrinKxWC/NYEUq6SrYIFeGiNolTBYkFYfPxPRZtEAAtlAADS2s677
   /sh5oK7VV4UTGNxLGJN//oxcd1jmG2di4Y6s0ceiqOduOLv4irfh8DmIv
   5C2e5NXQ4ulGMmJX7ksI8fVRrj2gQviqu2Q7Mkab8mQ5GGuEUu+31gaPx
   rbt7dbTkU6rEby+5d1t7ndKKmHj7lqzt2+nDthAemEmEqoVKH+Rqt9y6w
   xXtIpc0OfdwjgqdJRNCFunO1wjlAmnouHdjQ65+MhiAsQ45ld3PMfW0dl
   mNV4DHJfcHEqTAgKIQpJUq7f2lj26BnKo5iu6J907xW1+fSgF8dcb9m0E
   w==;
X-IronPort-AV: E=Sophos;i="5.90,201,1643698800"; 
   d="scan'208";a="152794019"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Mar 2022 01:07:55 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 22 Mar 2022 01:07:54 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 22 Mar 2022 01:07:53 -0700
Message-ID: <a47d223f28d9aa72536344f1cd7ab3c6cf91fca8.camel@microchip.com>
Subject: Re: [PATCH net-next 0/2] net: sparx5: Add multicast support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>
CC:     <davem@davemloft.net>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>
Date:   Tue, 22 Mar 2022 09:06:31 +0100
In-Reply-To: <20220321124717.610fdcdf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
         <164786941368.23699.3039977702070639823.git-patchwork-notify@kernel.org>
         <2c3b730d91c8a39e3e6131237ff1274dbd4b9cbb.camel@microchip.com>
         <20220321124717.610fdcdf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

I guess that Casper can fix the issues in a follow up.
What do you say Casper?

BR
Steen

On Mon, 2022-03-21 at 12:47 -0700, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 21 Mar 2022 14:33:34 +0100 Steen Hegelund wrote:
> > I have just added some comments to the series, and I have not had
> > more than a few hours to look at it, so I do not think that you have
> > given this enough time to mature.
> 
> Sorry about that. Is it possible to fix the issues in a follow up
> or should we revert the patches?

