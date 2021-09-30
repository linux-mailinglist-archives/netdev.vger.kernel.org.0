Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A52E41D2A6
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 07:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348060AbhI3FXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 01:23:22 -0400
Received: from smtprelay0063.hostedemail.com ([216.40.44.63]:34030 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1348034AbhI3FXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 01:23:17 -0400
Received: from omf12.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 14469182890C6;
        Thu, 30 Sep 2021 05:21:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id 9CE4B24023E;
        Thu, 30 Sep 2021 05:21:29 +0000 (UTC)
Message-ID: <553c081e8e4e8c3eb146f4ddf1ca24f9a007afa2.camel@perches.com>
Subject: Re: [PATCH net] MAINTAINERS: Remove Bin Luo as his email bounces
From:   Joe Perches <joe@perches.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yufeng Mo <moyufeng@huawei.com>,
        HuazhongTan <tanhuazhong@huawei.com>,
        YangShen <shenyang39@huawei.com>,
        Guangbin Huang <huangguangbin2@huawei.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Date:   Wed, 29 Sep 2021 22:21:28 -0700
In-Reply-To: <045a32ccf394de66b7899c8b732f44dc5f4a1154.1632978665.git.leonro@nvidia.com>
References: <045a32ccf394de66b7899c8b732f44dc5f4a1154.1632978665.git.leonro@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 9CE4B24023E
X-Spam-Status: No, score=0.10
X-Stat-Signature: 7naax7cn6i1n8yydr98c5ryz7f5r3wbg
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+z/T8rXjLgsomIod0rDoll6UM5B6ZtHao=
X-HE-Tag: 1632979289-163108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-09-30 at 08:12 +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The emails sent to luobin9@huawei.com bounce with error:
>  "Recipient address rejected: Failed recipient validation check."
> 
> So let's remove his entry and change the status of hinic driver till
> someone in Huawei will step-in to maintain it again.

It's probably better to at least cc the other huawei folks
that have also submitted patches for this driver recently.

> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  MAINTAINERS | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b585e6092a74..1e39189b4004 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8609,9 +8609,8 @@ F:	Documentation/devicetree/bindings/iio/humidity/st,hts221.yaml
>  F:	drivers/iio/humidity/hts221*
> 
>  HUAWEI ETHERNET DRIVER
> -M:	Bin Luo <luobin9@huawei.com>
>  L:	netdev@vger.kernel.org
> -S:	Supported
> +S:	Orphan
>  F:	Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
>  F:	drivers/net/ethernet/huawei/hinic/
>  
> 


