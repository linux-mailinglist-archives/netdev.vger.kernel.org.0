Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4449F397553
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbhFAOXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbhFAOXD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:23:03 -0400
Received: from fieldses.org (fieldses.org [IPv6:2600:3c00:e000:2f7::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9FE2C061574;
        Tue,  1 Jun 2021 07:21:21 -0700 (PDT)
Received: by fieldses.org (Postfix, from userid 2815)
        id ED88869D6; Tue,  1 Jun 2021 10:21:19 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 fieldses.org ED88869D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fieldses.org;
        s=default; t=1622557279;
        bh=ssO0Zcnn172GNJ5+u5TEp/J0tp9/5SxUu5MeXRgdXzU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ACL+fvqu8Aa/m+oLPSU4G1c0r/+2rLSIi4IPDBY1PLs4khIx3Mn0McCa95iT99QA/
         kh8ePh5RISeP6ynedosr7w4A9lPS2frUMAbTe84Wj/RnLqSXzswYR+Hk04HIVqZo3b
         OT6NZgOUwOBgXZibXwQrApZwh2jL/G2IB8q8bx74=
Date:   Tue, 1 Jun 2021 10:21:19 -0400
From:   "bfields@fieldses.org" <bfields@fieldses.org>
To:     zhengyongjun <zhengyongjun3@huawei.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna.schumaker@netapp.com" <anna.schumaker@netapp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chuck.lever@oracle.com" <chuck.lever@oracle.com>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= [PATCH net-next] xprtrdma:
 Fix spelling mistakes
Message-ID: <20210601142119.GB5320@fieldses.org>
References: <20210531063640.3018843-1-zhengyongjun3@huawei.com>
 <20210531222719.3e742ed6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <6b737fb5440d4fe3a53a163624d9cbf8@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6b737fb5440d4fe3a53a163624d9cbf8@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 06:34:04AM +0000, zhengyongjun wrote:
> Should I remove net-next tag and send patch v2? Waiting for your suggest :)

Applied for 5.14, no need to resend anything.--b.

> 
> -----邮件原件-----
> 发件人: Jakub Kicinski [mailto:kuba@kernel.org] 
> 发送时间: 2021年6月1日 13:27
> 收件人: zhengyongjun <zhengyongjun3@huawei.com>
> 抄送: trond.myklebust@hammerspace.com; anna.schumaker@netapp.com; davem@davemloft.net; linux-nfs@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; bfields@fieldses.org; chuck.lever@oracle.com
> 主题: Re: [PATCH net-next] xprtrdma: Fix spelling mistakes
> 
> On Mon, 31 May 2021 14:36:40 +0800 Zheng Yongjun wrote:
> > Fix some spelling mistakes in comments:
> > succes  ==> success
> > 
> > Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> 
> This should not have been tagged for net-next, leaving it to Trond.
