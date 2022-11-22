Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1171633C71
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233075AbiKVM2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbiKVM15 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:27:57 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8555213E9C;
        Tue, 22 Nov 2022 04:27:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669120073; x=1700656073;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Y/8E7lM2FYXG7OVZdD4/JamFVEBuUNQaRVQdD9CEyeI=;
  b=UmJCgfF9waNWplCtp5XSQk6RZm8fHuL10SooXjBH8ci1bpDb4xFqCrzs
   se2RtUbUBvQMJi5AHVjUt8k+0+Xhudxe+x/VNcEDi/GLGz3BY5eWHetTz
   vDbCv0DBOOJkYOxn2sfeHtnV151xGU06R2A2Cc6XSVSppSsgeRLtPcE+c
   eERFwou55ldFtIlr9FNI7Bzw+3/rT8E85VGFmJP+bQ7ZXoW/CoAYeU3Js
   zZqbHtx4z+q62GNWXXuEICRUrEUh+oFq/etmw/Bj0dneWF9HgfitXv3V3
   OdJ9RO69IoM+qKE4XaE9MB0rVGbKw+daEWHNzu4hzht7xwUPm2cb9tsHR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="297157607"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="297157607"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 04:27:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="641400458"
X-IronPort-AV: E=Sophos;i="5.96,184,1665471600"; 
   d="scan'208";a="641400458"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 22 Nov 2022 04:27:53 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 04:27:52 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 04:27:52 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 04:27:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KDhzBvwIjuL6ybnD1dywzSHubClO4ipMvGK52LN+iCypY0mIj+GqGK7jj3PdwnoIWlge3xijBfFnr+Dt2fdAnjJeZxicL/zuhSunG8efmbW5MTV9wpaIore7kfREnHVFLFBlei1VDB9UVQ/myjWv0ATiXAGmAYja6uE16X7WrZByBQGQyJazovBlnB92K2xKgY/qDTMGztlfOyWJsNkMT97mqKY/Q0STaT1HrKvXkPmMAhs0A/KpY6cmysvbc328OL51vQx8+yZp3iCAKCh1fT8wu03D97quRin4UpXhGe3FYXU5EOoFlhC/IDrhYrTVkXFp4ct0+xIjTT6GNoyiEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bhp0F0h46AQAV9u+8Z1CKeBex1n/w46aANpeDeINgBU=;
 b=b3iLSMAtsq6Ch3n5aeOhywAOeiTXbO4oGF8fq8Me+AlVeeoYp3bnR9cN7AiuIdWOr3GZdsNOO8URQZ7yvqcjVWw2O/ZH+6JkhelziTNv6r/66wbG8AqF4ig39ND4jb/fLUM07Q01PQ9wzu5sLEFHEHVcHu3918vnKiOsVfAjQ9yU1qzpK/nloMRjgGUKexhb/5jMfIoYjxW7mahuhcEPRyYBk5XpRYw8P8GNGyHIUkqyyT8+OlMUhLFgarhLAtWo9EhCGFFguLKA0e30E5nG+WEuB6ZozdyuvpQ5XKC3minRqqGkIubj/ABOVm2180ksrWHGIKvIWyvQ5ymr8HIu4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA2PR11MB4780.namprd11.prod.outlook.com (2603:10b6:806:11d::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Tue, 22 Nov
 2022 12:27:17 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::5f39:1ef:13a5:38b6%6]) with mapi id 15.20.5834.009; Tue, 22 Nov 2022
 12:27:17 +0000
Date:   Tue, 22 Nov 2022 13:27:04 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
CC:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: marvell: prestera: add missing
 unregister_netdev() in prestera_port_create()
Message-ID: <Y3zAGJhQVEnzQhAH@boxer>
References: <1669115432-36841-1-git-send-email-zhangchangzhong@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1669115432-36841-1-git-send-email-zhangchangzhong@huawei.com>
X-ClientProxiedBy: FR3P281CA0135.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::19) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA2PR11MB4780:EE_
X-MS-Office365-Filtering-Correlation-Id: 56c9a023-a3cd-4068-c642-08dacc84e49b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T6syR8V3Xf2NTMnkg3MTFJRXMReThLGzA136HmDZLIq9UbhPukPgjhzqibigLJlMrGalzK1E4vmE/PJk5DkzyvswTA4X0OJ4yIpTiJ+v+5+GAAuGWn1tJMbMQO/pyTSrUf+irO5V9qcdS5vYf8JpsJ5lmx1/QhJH1HPaZP4uNPC+ZMbUfogOEWDh7/kfDO88HNoM+rXv4Cy3Zutb8oZ2alyAAbWRwVCaK6m7OzOmdaxb79073+I/xbJdIwyclAXnCMYIhHEx9Igud5L6DMZR2wxUPR0gY49a4AXGr0Yyx8QD6Q8ZMR3ntA/X+49D5iQfxbtTNZZgKYQlURBfSC4/5kkU0dmSAk0lwbizhPtgkOpV77x1vGq2na9tGPe0wJf53bdyEcWjqFsuR9UA5s+NXnxcxBREDwJ33B4nH4bv5VVGLTURyBzHkrmQxKApGjOGRRdSMRkUm4ybsLOdjH+jojiA+Umd3jgi+qzXJLrmZUmNvlTVKSn/IDowtuu0DaOifBm92+6Ie31vXaRaFCtZqNIEpfTKLDTIgWFZ8MqFj4sh5ci+S6QW7axEKEVV4M/g5dHxE5MlCgHVQwttmP18X6fKnX/8aMS39S5104uV6H79Q3aApxPQs/EsMtRa3QR7uafYgMz2wBpkomsBsineCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(376002)(366004)(39860400002)(396003)(451199015)(86362001)(41300700001)(66476007)(38100700002)(44832011)(2906002)(82960400001)(7416002)(33716001)(5660300002)(8936002)(6916009)(478600001)(6666004)(6506007)(4326008)(6512007)(6486002)(9686003)(66946007)(66556008)(8676002)(316002)(54906003)(26005)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+KJadKdUj0u6Us69pu4aIQCP6eUF2wyrDAj0D1Mj91QKMP0czXbyA0OQQlga?=
 =?us-ascii?Q?nCl/wlVT2FUm7N8d8dbXNJbfpKXPYq5qhUzBNeebzT81ps2suwuDvO2mhKS/?=
 =?us-ascii?Q?7rKOUPnJXXS1k3tgclDfWUVydGVzRoHNVES+fwwrND6yFDjiuXAXRVb0vxCX?=
 =?us-ascii?Q?45M/TkHo3TeFIvM0uWeA/8q2Xv0t/NPHzcvqWSOMu/V6lfC7qsV1f2hmEir6?=
 =?us-ascii?Q?1FzxP7XQ8Lvy5QpE1BlKrFdxfM/6yye1atc6mIsmXzYdXeyogQNR8WcjcwsH?=
 =?us-ascii?Q?2EDavOZ9VnXAG/AriqlkJPEyrUHA3/Lt3CbFBn9T7DagErrlyjk3CVVGKwD0?=
 =?us-ascii?Q?1eP40hv0nQ13PQpZjmZ+Ymq3DNTSVGsG+q8TL5Fdvwon3dUWxflV8wyjlHBC?=
 =?us-ascii?Q?k8l2b8SQzkiFnibvg5L4WlNWDZMIuDZCxGL1Za21rTWoc58S5qTnQTK3HBeZ?=
 =?us-ascii?Q?EJWi0ILepCN9QHPb+3YOHcLIVJCWHc2BwrNJMyBci72/ilJoG+gqBc0lgvNi?=
 =?us-ascii?Q?Raq7nAuChhQhICUmk2rpZ591qW9v7+QIsvlsyfY9tq0lPWG3Sgr0AouFQOGH?=
 =?us-ascii?Q?x8qvy6zhKoUL190kSCkqe1rVnMNJlsWtYJNFkrCNzgzmVPiO1kYyYwKm9tg7?=
 =?us-ascii?Q?2uUNaAwyfPwm/XCB9x2+3P1IFO1LcY6RK/gQtZouS//5lWektaHi4FpYSZU8?=
 =?us-ascii?Q?oVT1TjA+BqPFiNHB0ACL17mpNmZawekpJnPGr0L4Us2GwtC1g/iBUf374+jh?=
 =?us-ascii?Q?3VN6BE+awjRYvUtG2HztDRuHjAUubbf4/H2Y0vGblOordHoVsFjWiUKh6u2/?=
 =?us-ascii?Q?amMH37OJld1EAAIOl+AweDCr623oGPKUZKo+KxQWIVGZ1gOjh0VlHi4R4Axi?=
 =?us-ascii?Q?KEFrDeWjdM9CCLi4yZT6VD+su3T+qvMNDFEbiY9L7v4YXfdrmjozaukKXAwR?=
 =?us-ascii?Q?5kE8IAp8IvSXnbaK4yP5qMcZPXlCtiB1yCd2YMPqkImxqtnckZZcYf2tQX+I?=
 =?us-ascii?Q?pATayI3YHlqNLat1MsqdA7j2uQ6xaZui/1hDL4Ml1pRGcInw/NvzwU6BYCqm?=
 =?us-ascii?Q?7fsQVhv3AXrMKnwpdlpSoXfH6560jyYM9fixz9rf/KqnQYZJkLJNi1MhXScf?=
 =?us-ascii?Q?0zrTkDV7LETHbUOYo0RqjSw+Hr6Y3oj+rwUN1WTJGCvOHzz88dnfhjaAa3bI?=
 =?us-ascii?Q?Z6MIfoWOjSr9vK7mHNEcKbF4NjcNV90HYlHuOlTtdPZAQbkTkgESuIv7t4wC?=
 =?us-ascii?Q?AnXTlGNFJKD+QW/9oocS8yTBNydOGiMD1RMnDF3gAdhsElumDsku5eC92k9z?=
 =?us-ascii?Q?XMjPjkqzMe+jlVXgOnbV1Girs5uw+H+eWMSA0/WB4XE7PPVLlIiV/nrg1OoH?=
 =?us-ascii?Q?Xk2SHl6MazXg6EzjLcygivVw5otW34LdgGQVJDPEhnv+ghcf1RyKH+uLcjue?=
 =?us-ascii?Q?TENyKY5OFQgTZpnV6eKFeW9iYYYPukR1de7KeafBgMVpTa0sSbx6dPHjjeR5?=
 =?us-ascii?Q?i7ojr965aavCb4fDc4gCn4vH33Dh5+xCWsvttm+NafxM441LX2rqcGJ11yJx?=
 =?us-ascii?Q?3mj8LYegoPjgsUM0UeFzie6qJLx6ecRML+EF1HAFS8FSkBDSpRthyKhAiVq6?=
 =?us-ascii?Q?5A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 56c9a023-a3cd-4068-c642-08dacc84e49b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 12:27:17.0603
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SspCDrbSRyLtxs4a6w6KbpU7OX7pLsR20i9zQjLkXEkCyhym1XD+uYaKboRikQOtef5cONmWQ/66OodP9v6+FiUYx/lemPxy6+jZvsrePbo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4780
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 07:10:31PM +0800, Zhang Changzhong wrote:
> If prestera_port_sfp_bind() fails, unregister_netdev() should be called
> in error handling path.
> 
> Compile tested only.
> 
> Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>

Makes sense and fixes commit is correct.
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/marvell/prestera/prestera_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> index 24f9d60..47796e4 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
> @@ -746,6 +746,7 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
>  	return 0;
>  
>  err_sfp_bind:
> +	unregister_netdev(dev);
>  err_register_netdev:
>  	prestera_port_list_del(port);
>  err_port_init:
> -- 
> 2.9.5
> 
