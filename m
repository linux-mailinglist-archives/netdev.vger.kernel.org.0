Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B684523829
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 18:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344301AbiEKQJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 12:09:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237427AbiEKQJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 12:09:40 -0400
Received: from mail1.bemta31.messagelabs.com (mail1.bemta31.messagelabs.com [67.219.246.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 284D922B3A7
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 09:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lenovo.com;
        s=Selector; t=1652285378; i=@lenovo.com;
        bh=QwOQULTtlcrP5pEfgK0bbcNdqCbkm2A5yV2p/Pyw2vQ=;
        h=Message-ID:Date:MIME-Version:Subject:To:References:CC:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=P1CYgyqI64KrdeUv6r1ym+vYk+BU+JosFBeR224GsR7nHYt+HTn3M56uZ5cvU3DHU
         5NsjQuFuoitbjjCe9roWC/I3w1bqdJhRTDYZz4QD4d18f9Qk+Y2hYXVAqiZiq9um+/
         rsLGjZb4tFzjgwEif/uJG5OI+722vxoBcAqItxlps83I1KLr0AIXikTbgy5UG4GFSi
         mM8YV8Yyt7uOAw+nE3nP5FsSOv3Hi2uv4W0sewLrdCcLYr8lVSaohYv/TpVl/ZTTYP
         I/E5BEaKIvMBP/4SJzJIKsOQS247+vRbq2nnZr3IJ5Da5QyDOumDW0Wd7ELv74FIB/
         9Wjvj6VHG8pSQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFJsWRWlGSWpSXmKPExsWSoZ+no3vwfnW
  SQf93RYv/M8+xWvzczmYx53wLi8X3Tb2MFtMO9jBaHFsg5sDmMauhl81jy8qbTB47Z91l9zi4
  YCqjx+O3m9k9Pm+SC2CLYs3MS8qvSGDN6O7qZir4zlPx+s9atgbGvVxdjFwcjAJLmSWmzbvBA
  uEsYpWYMLeRFcJpY5KY/GsGE4gjJDCHSeJn9x42COcAk8SBH0vAyiQEjjNKTDuxmgUi08koca
  ZvPlTPRCaJ9yumQmWeMErc/n0WynnFKHFh/0tmCOcBUM8nkDJODl4BW4nJU28zgdgsAqoSx57
  OYoKIC0qcnPkErEZUIFyie/9+VhBbWCBBYtf2dWA2s4C4xK0n88HqRQS0JE7fOga1bT2jxN2f
  m9lBHGaBNkaJ3bffMoJUsQloS2zZ8osNxOYUiJU4eWg+O8QkTYnW7b+hbHmJ5q2zmUFsIQFli
  V/954FsDqC/5SU2nUkECUsAHdE85SgjhC0pce3mBXYIW1bi6Nk5LBC2r8Tu9ouMEK26Eu+eu0
  OEcySOrvrMOIFRbxaSN2cheWcWkoNmITloASPLKkarpKLM9IyS3MTMHF1DAwNdQ0MTXWMgaa6
  XWKWbqFdarJuaWFyia6iXWF6sl1pcrFdcmZuck6KXl1qyiRGYzFKKmEt3MO7v+al3iFGSg0lJ
  lDfvanWSEF9SfkplRmJxRnxRaU5q8SFGGQ4OJQle5rtAOcGi1PTUirTMHGBihUlLcPAoifC+A
  knzFhck5hZnpkOkTjHqclzZtncvsxBLXn5eqpQ476/LQEUCIEUZpXlwI2BJ/hKjrJQwLyMDA4
  MQT0FqUW5mCar8K0ZxDkYlYV6re0BTeDLzSuA2AVMU0P0ivPtdK0GOKElESEk1MNm4+/JX3ky
  K9ub6+0hPaO/Fm7rlup/0jE1m5T3aYFobVFTUumjyBIX3JQZJWSfPJgpq/GxZ4MnK0/CepflM
  dc2xh6nXWHor6g+cTmz4fdc5x87lsN0pIaG70q7n++RfFhbW+sb+Cpr4/oN/rk532vvJjMeCj
  Fd+uWq6WrKSTdCV62Dz/TsOQYvi9Ho1Q7+V/d19K7bZ+JqeTEFX2d5zUwRr2JgWpK1kjDrw/V
  5KrvbKPbxXJ9mXrgmf0BXz+SbrFqEOzaIIcfs6Py+eycv+xwkEW3h1hJzgj/+jdcu+NnBJ/ZJ
  vN23Sq1oMD4asfn/58SHPU9l38954mrZck+Nd/fiM0n+PrxerxOP8jeuUWIozEg21mIuKEwEX
  zV1ibQQAAA==
X-Env-Sender: markpearson@lenovo.com
X-Msg-Ref: server-12.tower-686.messagelabs.com!1652285375!58650!1
X-Originating-IP: [104.47.110.44]
X-SYMC-ESS-Client-Auth: mailfrom-relay-check=pass
X-StarScan-Received: 
X-StarScan-Version: 9.86.4; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 3678 invoked from network); 11 May 2022 16:09:37 -0000
Received: from mail-tyzapc01lp2044.outbound.protection.outlook.com (HELO APC01-TYZ-obe.outbound.protection.outlook.com) (104.47.110.44)
  by server-12.tower-686.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 11 May 2022 16:09:37 -0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dhu78BMTTv57kl1f5LbpupfiKSH+9xkT9CQJIav7vYPp0cAvIU5gHH2hrrFEQeE6br+ngt4+XJTp/NqgFH72QcyxBOTiZinJZNAunaIKNqcKqeMzI29gut4IRWGwWkS6gdbJ/Xy0+vN9BXYR/bb8s+pc3KO+N5A9HSYX1pPLZl+wKVTAX5P2bjpwxGrdf973Kttqfo0kkoNil44ewAqwLuA8MsCe4UPkbrh6HnBMEMcta/9ibbeDPX3CbKWDW0zwfGs5KTbCGmuXKVE2eBddliZOTdHt1mgLztSZckAq5NZq+AhaZ/XBZMLKzePvVjIFEcFwOr+4DMuXAAVzVHk5bA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QwOQULTtlcrP5pEfgK0bbcNdqCbkm2A5yV2p/Pyw2vQ=;
 b=TjpyXdhFEVTDCk2URn7YbASmTgoBOrB6gJXD/jRd96We5S7EFh/7GvWLUZKEl8ZVQuGlAzWLiKfffVRXVaKedrniBUkA1SgBCU8yNx8Tw3rPXktl8EHrQqosJxpgNzE0cSjLv+quN5N19onwgijCRMVJRyCK1igF4mxtMaRmEJoyqjsHljGJANVK3GjIt/AS2kPFgoNTR6Ou/H2L2xiCaoqDRWyroVArtG/pYnrxw4aks6ef+K2hgP8zx+cs02SeChyt75dbCAH5xU6OoTRKy0F1QNBAu14wYpeNweKnppcRpYDg89T/3AUt6FbDp1u8i4DkFmHnVwpE1Umi2YbHdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=softfail (sender ip
 is 103.30.234.49) smtp.rcpttodomain=mork.no smtp.mailfrom=lenovo.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=lenovo.com;
 dkim=none (message not signed); arc=none
Received: from SG2PR02CA0018.apcprd02.prod.outlook.com (2603:1096:3:17::30) by
 PSAPR03MB5640.apcprd03.prod.outlook.com (2603:1096:301:61::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.12; Wed, 11 May 2022 16:09:35 +0000
Received: from SG2APC01FT0025.eop-APC01.prod.protection.outlook.com
 (2603:1096:3:17:cafe::2d) by SG2PR02CA0018.outlook.office365.com
 (2603:1096:3:17::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14 via Frontend
 Transport; Wed, 11 May 2022 16:09:34 +0000
X-MS-Exchange-Authentication-Results: spf=softfail (sender IP is
 103.30.234.49) smtp.mailfrom=lenovo.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=lenovo.com;
Received-SPF: SoftFail (protection.outlook.com: domain of transitioning
 lenovo.com discourages use of 103.30.234.49 as permitted sender)
Received: from mail.lenovo.com (103.30.234.49) by
 SG2APC01FT0025.mail.protection.outlook.com (10.13.36.187) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.13 via Frontend Transport; Wed, 11 May 2022 16:09:33 +0000
Received: from HKGWPEMAIL01.lenovo.com (10.128.3.69) by mail.lenovo.com
 (10.128.62.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.27; Thu, 12 May
 2022 00:09:33 +0800
Received: from reswpmail01.lenovo.com (10.62.32.20) by HKGWPEMAIL01.lenovo.com
 (10.128.3.69) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.27; Thu, 12 May
 2022 00:09:32 +0800
Received: from [10.38.56.73] (10.38.56.73) by reswpmail01.lenovo.com
 (10.62.32.20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2308.27; Wed, 11 May
 2022 12:09:29 -0400
Message-ID: <8a612930-b3f3-9f3a-4dde-fe6b65811ca1@lenovo.com>
Date:   Wed, 11 May 2022 12:09:28 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2] net: usb: r8152: Add in new Devices that are supported
 for Mac-Passthru
Content-Language: en-US
To:     <bjorn@mork.no>, <dober6023@gmail.com>
References: <20220511133926.246464-1-dober6023@gmail.com>
 <874k1wdv5j.fsf@miraculix.mork.no>
 <TYZPR03MB5994FC7F39B7613FB568247EBDC89@TYZPR03MB5994.apcprd03.prod.outlook.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <hayeswang@realtek.com>, <aaron.ma@canonical.com>,
        David Ober <dober@lenovo.com>
From:   Mark Pearson <markpearson@lenovo.com>
In-Reply-To: <TYZPR03MB5994FC7F39B7613FB568247EBDC89@TYZPR03MB5994.apcprd03.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.38.56.73]
X-ClientProxiedBy: reswpmail01.lenovo.com (10.62.32.20) To
 reswpmail01.lenovo.com (10.62.32.20)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d217d2b-f2ad-4cb7-ad4a-08da3368a38e
X-MS-TrafficTypeDiagnostic: PSAPR03MB5640:EE_
X-Microsoft-Antispam-PRVS: <PSAPR03MB564022BEB68F16ACBCE42B67C5C89@PSAPR03MB5640.apcprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHM6EUkm55umtCuhDlWp9f/YJ8f1ax6a/gbgJVFbwgwdIZ5A1LauJtEgcqXkh7A0ZIp7vixafzWFxGuMFxwkHWb6prsBklo8Dakx64VNaQ+CAyCZc2RQ4faxCk3n+uJ5yJ+SKBHnY6up/iyYlXx+4TcfIMmyfw2vmGkfDVsGqxgz77fX6jiGOrKGFD86gksMn43ii0yy+Ly+JZkKVpVG503R5M8L1ViZdNEo8QsH8eJBB8mo6aLJAiSvXpCnDuWrF23uOE7v+XLcc9hRrocl4BdDa6m74Eyzn3Cal1tDtm1nVdsXiATn5liXpajO7GRUdhJIs4yPFaHlr0Yi/L+r7mQOEmY82zOfSWN9WUB6V94GE+0lG+ecfHsbJaMYW8WmFAPn52JbNITPLxmq/PLTk2rbtt2hh0lRvZlGgMvLMw14xlWdHZxF0uycc9TZaBexNs8AnRBq+KpEICRFbRLuH8L0nZ00k1X8CQqham1LOOUBqN9fYTvMU4DR7rtshog1HgbZFQtxdLuMW1DRNmUosrTD7lZXhgTZdiX+pe+RCxF8aeB7X1YODVIA4XDrE3dgHFYvA5eF1HXL1XfFrMzDOufx9ldN43D2xLIt0C605/20r+bIcAC5wHwxYN5tGJKJRN2dej7sZhQ+7atiZsGKfmcZ8sGYNqRCR9adtStFUfane2xq1fv4ACM/BCMVH9ihBkzyoguF50OwZNRtk5kIf0Zga4oHMQqaU5fNGuawAaZjsXRjmztEoK7q667Z0UUl3eyMIQJsY57rAeP9fDirLw==
X-Forefront-Antispam-Report: CIP:103.30.234.49;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.lenovo.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(16576012)(54906003)(40460700003)(86362001)(2616005)(107886003)(110136005)(186003)(16526019)(31696002)(36906005)(83380400001)(356005)(82960400001)(508600001)(336012)(26005)(47076005)(426003)(81166007)(316002)(66574015)(2906002)(8936002)(82310400005)(36756003)(36860700001)(70206006)(8676002)(70586007)(4326008)(31686004)(5660300002)(3940600001)(43740500002)(36900700001);DIR:OUT;SFP:1102;
X-OriginatorOrg: lenovo.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 16:09:33.8592
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d217d2b-f2ad-4cb7-ad4a-08da3368a38e
X-MS-Exchange-CrossTenant-Id: 5c7d0b28-bdf8-410c-aa93-4df372b16203
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=5c7d0b28-bdf8-410c-aa93-4df372b16203;Ip=[103.30.234.49];Helo=[mail.lenovo.com]
X-MS-Exchange-CrossTenant-AuthSource: SG2APC01FT0025.eop-APC01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB5640
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Bjorn,

> *From:* Bjørn Mork <bjorn@mork.no>
> *Sent:* May 11, 2022 10:02
> David Ober <dober6023@gmail.com> writes:
> 
<snip>
> 
> I beleive I've said this before, but these policies would have been much
> better handled in userspace with the system mac address being a resource
> made available by some acpi driver. But whatever.

We did look into this - but it got really messy quickly with moving
between user and kernel space and assigning the MAC. We didn't spend
ages on it but came to the conclusion it was far from easy.

I'm very happy to do a patch in thinkpad_acpi to expose the MAC to user
space (via a sysfs node) and to use that to work towards a better
solution, but think we'll need help for determining how that would work.

In the meantime we'd love the dock and the dongles to work for Lenovo
customers. We have had a bunch of customer issues raised where they're
using the system MAC (for either system ID, or in PXE server setups)
where not having this feature work has been a pain. The feature is used.

I believe David is going to address your point about the IDs.

I'd like to continue with this approach until we have something better.
Any suggestions who should I talk with for a longer term solution?


>  I look forward to
> seeing the FCC unlock logic for Lenovo X55 modems added to the
> drivers/bus/mhi/host/pci_generic.c driver.
> 

I'm afraid that cannot happen - and I don't really want to drag this
thread sideways on that topic as it's completely not related. I'm very
happy to have a separate conversation about it (either privately or
publicly) if it will help. I will happily agree the FCC unlock sucks.

Mark

