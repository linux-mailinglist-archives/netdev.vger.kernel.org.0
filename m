Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0FB6E6BF2
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 20:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbjDRSTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 14:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjDRSTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 14:19:09 -0400
Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541E830E0;
        Tue, 18 Apr 2023 11:19:05 -0700 (PDT)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 36C81280069;
        Tue, 18 Apr 2023 18:18:59 +0000 (UTC)
Received: from [192.168.100.159] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 17EF513C2B0;
        Tue, 18 Apr 2023 11:18:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 17EF513C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1681841939;
        bh=Hk6g0oaH3M55RMzooqmaVpKLChsPYkWso8S7ZP9kkaQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=H7k4Mb8jCEsTofd/mhMJmA40wJV6Jk6jwl2eGq/3n4iMoSyt1nAOlyb5dMO+z4gjp
         179rekKt/QgNb/qoCB6kXLrO7nwBVRRm+NHY0kHslsu1p9nYz912xw/6or3BxZ+VE5
         OwEd9uJmffJ/N7fHCDt/AGRy9hAirTGktYo/E11w=
Message-ID: <7e068d1a-101e-b3b6-9f8f-f2208433cc29@candelatech.com>
Date:   Tue, 18 Apr 2023 11:18:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 5.4 182/389] PCI/portdrv: Dont disable AER reporting in
 get_port_device_capability()
Content-Language: en-US
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bjorn@helgaas.com, LKML <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Stefan Roese <sr@denx.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bharat Kumar Gogada <bharat.kumar.gogada@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Yao Hongbo <yaohongbo@linux.alibaba.com>,
        Naveen Naidu <naveennaidu479@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230404170952.GA3559293@bhelgaas>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
In-Reply-To: <20230404170952.GA3559293@bhelgaas>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1681841942-gLVvMYzf_5n2
X-MDID-O: us5;ut7;1681841942;gLVvMYzf_5n2;<greearb@candelatech.com>;5edbc7074fcd6213bbe8a79eff83db95
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The CC list in this email is huge, and the dmesg is also large.  I'm going to send the file directly to Bjorn.
Please let me know if anyone wants to see it, or if I should just reply-all and paste it in...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


