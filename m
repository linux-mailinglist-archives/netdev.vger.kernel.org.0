Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E70B17E670
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCISIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:08:09 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34604 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726169AbgCISIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:08:09 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BE4D0680074;
        Mon,  9 Mar 2020 18:08:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 9 Mar 2020
 18:08:01 +0000
Subject: Re: [patch net-next] flow_offload: use flow_action_for_each in
 flow_action_mixed_hw_stats_types_check()
To:     Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pablo@netfilter.org>,
        <mlxsw@mellanox.com>
References: <20200309174447.6352-1-jiri@resnulli.us>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <802486d8-5b17-09c8-3f31-0064a83b66dd@solarflare.com>
Date:   Mon, 9 Mar 2020 18:07:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200309174447.6352-1-jiri@resnulli.us>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25278.003
X-TM-AS-Result: No-0.109100-8.000000-10
X-TMASE-MatchedRID: Oc0zQINXvg68rRvefcjeTfZvT2zYoYOwt3aeg7g/usCbKItl61J/ycnj
        LTA/UDoA+S9X7PfvVMrkwjHXXC/4I8ZW5ai5WKlyIxGlQMnJZquMIAOoVfjAKVHtzCZGuByxF5X
        WG2gZ+1dISK8ZbOBuJdQ17CngTb9OBKmZVgZCVnezGTWRXUlrxxtsJUxyzWNSVlxr1FJij9s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.109100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25278.003
X-MDID: 1583777288-NRMGssNQEdIN
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/03/2020 17:44, Jiri Pirko wrote:
> Instead of manually iterating over entries, use flow_action_for_each
> helper. Move the helper and wrap it to fit to 80 cols on the way.
>
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>
Acked-by: Edward Cree <ecree@solarflare.com>
