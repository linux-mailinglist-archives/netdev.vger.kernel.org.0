Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB3361120
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233609AbhDORbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231726AbhDORbM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 13:31:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6256E610F7;
        Thu, 15 Apr 2021 17:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618507848;
        bh=dKfAf/aDv/tdGxtXMfgEjbcTlwuPGbWld18r8m4kFso=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k4gDI0SYhaXUTJ+hfkvcYLmOPavuhPJaDSRDxAlsdMjMVFDlsLc/Cx9QaPX9o5BqE
         terIbdSSB0YC4DKk01xFLuEgrU/jBco7F+nOXXklppPIzptaJheKxvlueGuA6IVELf
         RcTwBOngJHe+6Pomo7zOOt9pqh621Mlppm+e+H9MLM37H92Sg+nJneYZ40leHo8/Vw
         GoNnJrByzB4RfLCBiA5OZKd04PX31VTrLDh/eB1xCMhvo2EpT4tBjo036qOm4cbVFC
         +ftXc5Iw/9HUyHRjVJgfAIDX78Ir4crVakq8Vo2ohvoyE3PQ7crWjaBefS0nCrPoNP
         FcWyjN5OUI3Yw==
Date:   Thu, 15 Apr 2021 10:30:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, borisp@nvidia.com,
        john.fastabend@gmail.com, secdev@chelsio.com
Subject: Re: [PATCH net 0/4] chelsio/ch_ktls: chelsio inline tls driver bug
 fixes
Message-ID: <20210415103047.384db0fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415074748.421098-1-vinay.yadav@chelsio.com>
References: <20210415074748.421098-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Apr 2021 13:17:44 +0530 Vinay Kumar Yadav wrote:
> This series of patches fix following bugs in Chelsio inline tls driver.

Nothing objectionable here.
