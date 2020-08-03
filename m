Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02A423A754
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 15:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHCNPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 09:15:25 -0400
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:1221
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726239AbgHCNPY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 09:15:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V45Pz1MrfzjFhjKespqEwsVVEvDWH8qUgw9dgPxIzhozGOwKMAzoCMtTzqPW2dMSHsRNU0Yym6XVXs6QeiyGfP9YzGhq8xPBxmu1GthXdNAmWyo89Bz7R+WV4cviplB0f2UinXGQaX4ypEI9JF/sh0uGhrSq7B+N6KSE9pJ/UOXwqPmgIYtQxE39H8cu02KV1PauZXeG45BAtDEm/EqdtyqroI4XWUyAruUqE9Max15I0imWaBA0BCikA0WJ92qxcJCJ95bsnRJCVvj0oinpCG5oCWr8YIBP3Ly5GEBaHu1x1oeiJ+NcrEYlHrRfsWEYyIz8naeZPCbpSHBdzJavxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSHyhENIgNXewMN32KerI2Jka48E6vm4lXoA0lEZjI8=;
 b=jQlDA+f7XcL/qNdX3yLLajgE4n5/2hdD8Ws4DvSfSju2aZm2QaXHszUefrS+oGgUtaWFFc9LxOt5rN6mZCArZ/FrEWsHmiKWgKHnF+V0ac0CPhadBjoSWJPkP4GaITEbrLMWaTPJ2PgtK0/+wz9qb4FPsedjqfY3b3yYO0tKbWsUDs+SJgChUOstYkasxil0HRJ3USSat+MxaELUEYsC7QHJmkQtwt8sKy9yH/jTcpwzF4j9oSvC58diIgs3FyULLDiUCB66ChHRTeBjv6736u5b7EjaIlKyoR1gVacLXQ2Lbbu+/J7LEY8DQ1bE7kjhR5SKwPjoGMeAA5fggbdMDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hSHyhENIgNXewMN32KerI2Jka48E6vm4lXoA0lEZjI8=;
 b=D2pUYqQFrbLROyA36AbR7VtXJ3mzP6VSG+Or5pTcQS1AsdKd6FOqzlBKuDwU1q3bDDzLSVUH+Mp78Zaj1mT8X6bz4wS0JROfOX3YaVkvVJfVOFvtWrpiMCCegJZ4kbYUTp/7ijgtjBdFZ81xDscXvzMxL9aLEk76LWKLkuSJgsY=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com (2603:10a6:5:18::21) by
 DB6PR0502MB2997.eurprd05.prod.outlook.com (2603:10a6:4:98::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3239.16; Mon, 3 Aug 2020 13:15:21 +0000
Received: from DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::84:f8d2:972:d110]) by DB7PR05MB4156.eurprd05.prod.outlook.com
 ([fe80::84:f8d2:972:d110%7]) with mapi id 15.20.3239.021; Mon, 3 Aug 2020
 13:15:21 +0000
Subject: Re: [PATCH net v2 1/2] netfilter: conntrack: Move
 nf_ct_offload_timeout to header file
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20200803073305.702079-1-roid@mellanox.com>
 <20200803073305.702079-2-roid@mellanox.com> <20200803103916.GB2903@salvia>
From:   Roi Dayan <roid@mellanox.com>
Message-ID: <624429ca-5d63-78d4-f4df-c1fb53a409c0@mellanox.com>
Date:   Mon, 3 Aug 2020 16:15:16 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200803103916.GB2903@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM4PR0302CA0027.eurprd03.prod.outlook.com
 (2603:10a6:205:2::40) To DB7PR05MB4156.eurprd05.prod.outlook.com
 (2603:10a6:5:18::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.170] (176.231.115.41) by AM4PR0302CA0027.eurprd03.prod.outlook.com (2603:10a6:205:2::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Mon, 3 Aug 2020 13:15:19 +0000
X-Originating-IP: [176.231.115.41]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 509ab2b0-eb52-4aff-9012-08d837af461d
X-MS-TrafficTypeDiagnostic: DB6PR0502MB2997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0502MB29973725A2907E16C2774443B54D0@DB6PR0502MB2997.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kmk6L0mQ45u8fPFrv13i72BNYDm4Ce+IAb9YhiDLopSMdYXXf54eTuZb2oYG6fJRNGG0lwzRay++iirZh70VPE7LZY+MifISSGoFy9wQVAtCBYdyk0tsEZqsPCRKOYqByRgTCV+LPQKGlMJ3F6J0bbzJ1PAW9O5IxKebNnrRWjn13hutNbxlJEzfUENozMXMelg0Guy/5YroDVIfFo/a1ZDF/EeSNM7hXz+K+Yh7HbozwfMB9+TOKKvJEtcUk7FpsmZ5wf6Ji8anRsjoQDHsafbBaqsLLayQ17qyuA44roMfW7V5NmccrjTnuWAxi2pCDbSe8PyzmMgQh9xb/EsyvKxbGOpoJGNrOLIgQXucNB1/EdXAa3Mpb/VrlGazVltw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4156.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(396003)(366004)(39860400002)(956004)(86362001)(2616005)(6666004)(6916009)(186003)(316002)(31686004)(54906003)(4326008)(8936002)(16526019)(31696002)(6486002)(66476007)(66556008)(66946007)(26005)(2906002)(478600001)(53546011)(52116002)(83380400001)(8676002)(36756003)(16576012)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TD57eOuujBcblJh2nb4tSM8pX0UE+L+gpYp+Uhdby26A1c5e4n9mKC5Z2jcOJHIUQYjs7z4NsVSkbnSkf0iSyZnmz5Bl+4Ct5oX5+lGhccJYsGeXarAsqpk/uPuE55jUDbvcd4ArR5ZUyfiWlV3D3kHYSXKFDSg+6CaOjrxyZksU5f0NokEbHUTGlH/veAW4nwIv/nlfgVlpiwqhRcKf/CD7HCwpGwJdNI93It44B44mKjNmTKI6vz3iLSvWnvEt+h4sADR3T13cFNDeDDu/utggto4rHx1P48zMtKySHiubG9KVOAd3An00SbpMYO6vOpRcpxF9K/OMuSzF3ldbKbScR4LDo9CHbpIgcE7deQf3wRn5uGPzW+ZLZX2D3mJrEvwaFSUHg679EhKYBlc1WxJX+V6bGAH5ScBvtcIAXZ23uwGXjfqHZe0U0M6JnXeHCjitGYtEeNNlqidOxHs1a+m4jv9QU+FcPQTuQDBOQ54P3f6bmF7/droMGa//jnu4jJcsijmKv/pUqFBeBNA0bglWfbrfUvjsQXrps7FkGFIBL+XqEWOY082ReTdBIpD4HrqVrHmvIrJGFPS/65gqLjvVvLM65x0vJEYWj+DzflgbausnGQZiIo0vMztSGKshQlO/xJjCB7gP381uHMHGKw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509ab2b0-eb52-4aff-9012-08d837af461d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4156.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2020 13:15:21.2009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /lVQoGphXObqtQhsMKzxrSW3BdPTnXKPPArsUnJ2YQ6qQAAtXuBs0FAvRHP+KAk4GkfDjExKb1xNsXawTRRynA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2997
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2020-08-03 2:03 PM, Pablo Neira Ayuso wrote:
> On Mon, Aug 03, 2020 at 10:33:04AM +0300, Roi Dayan wrote:
>> To be used by callers from other modules.
>>
>> Signed-off-by: Roi Dayan <roid@mellanox.com>
>> Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
>> ---
>>  include/net/netfilter/nf_conntrack.h | 12 ++++++++++++
>>  net/netfilter/nf_conntrack_core.c    | 12 ------------
>>  2 files changed, 12 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
>> index 90690e37a56f..8481819ff632 100644
>> --- a/include/net/netfilter/nf_conntrack.h
>> +++ b/include/net/netfilter/nf_conntrack.h
>> @@ -279,6 +279,18 @@ static inline bool nf_ct_should_gc(const struct nf_conn *ct)
>>  	       !nf_ct_is_dying(ct);
>>  }
>>  
>> +#define	DAY	(86400 * HZ)
>> +
>> +/* Set an arbitrary timeout large enough not to ever expire, this save
>> + * us a check for the IPS_OFFLOAD_BIT from the packet path via
>> + * nf_ct_is_expired().
>> + */
>> +static inline void nf_ct_offload_timeout(struct nf_conn *ct)
>> +{
>> +	if (nf_ct_expires(ct) < DAY / 2)
>> +		ct->timeout = nfct_time_stamp + DAY;
>> +}
>> +
>>  struct kernel_param;
>>  
> 
> For the record: I have renamed DAY to NF_CT_DAY to avoid a possible
> symbol name clash. No need to resend, I applied this small change
> before applying.
> 

thanks
