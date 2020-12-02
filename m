Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B900C2CC78B
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:14:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387835AbgLBUN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:13:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:59992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387412AbgLBUN3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:13:29 -0500
Date:   Wed, 2 Dec 2020 14:12:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606939968;
        bh=Iykhya6FOdK4tHivQlBpTlZS4zh7Oi+Xg4iRs0sIZ4A=;
        h=From:To:Cc:Subject:In-Reply-To:From;
        b=igL4lgZ9kTsNKazSQtXmu63EG+hgbA7n6BI0M9Tc5C8btJ9lzuL5IJnymKudUfRuA
         QmyoRaK75Wyh4eOdGuu8Zx2T5FrQBk2curt2fTH69RwxzqV8PrK21fPdLI+zON9cQ+
         IWxc1NFpiZrRM6dcdh0fz0u+4+u59YU7m4iR52CRqmtvN/hdokkROXutCbEXsCftpC
         IjJmFOOhNIMb7SJsg5XDI5fgc13Lt/G0+ehV4yJAzy6NKuDRdmcn/w8xq1EORWV6oS
         EIRZY+/rZtxkvTt+CAzPHJ4f47mQG5e6k8qfQf4JhVOnqeUjRKsYt4aPmobfOdjbWg
         HGJ/lapMFHBzg==
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mario Limonciello <mario.limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com
Subject: Re: [PATCH v2 4/5] e1000e: Add more Dell CML systems into s0ix
 heuristics
Message-ID: <20201202201246.GA1467134@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201202161748.128938-5-mario.limonciello@dell.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/s0ix/S0ix/ in subject.

On Wed, Dec 02, 2020 at 10:17:47AM -0600, Mario Limonciello wrote:
> These comet lake systems are not yet released, but have been validated
> on pre-release hardware.

s/comet lake/Comet Lake/ to match previous usage in patch 3/5.

> This is being submitted separately from released hardware in case of
> a regression between pre-release and release hardware so this commit
> can be reverted alone.
> 
> Tested-by: Yijun Shen <yijun.shen@dell.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>
> ---
>  drivers/net/ethernet/intel/e1000e/s0ix.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/e1000e/s0ix.c b/drivers/net/ethernet/intel/e1000e/s0ix.c
> index 74043e80c32f..0dd2e2702ebb 100644
> --- a/drivers/net/ethernet/intel/e1000e/s0ix.c
> +++ b/drivers/net/ethernet/intel/e1000e/s0ix.c
> @@ -60,6 +60,9 @@ static bool e1000e_check_subsystem_allowlist(struct pci_dev *dev)
>  		case 0x09c2: /* Precision 3551 */
>  		case 0x09c3: /* Precision 7550 */
>  		case 0x09c4: /* Precision 7750 */
> +		case 0x0a40: /* Notebook 0x0a40 */
> +		case 0x0a41: /* Notebook 0x0a41 */
> +		case 0x0a42: /* Notebook 0x0a42 */
>  			return true;
>  		}
>  	}
> -- 
> 2.25.1
> 
