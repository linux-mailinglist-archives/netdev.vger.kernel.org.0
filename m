Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0C1393890
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 00:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbhE0WMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 18:12:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233563AbhE0WML (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 18:12:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C225611AE;
        Thu, 27 May 2021 22:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622153437;
        bh=a7vl2bBWILqAfTr+YefHtdpPo+E4oW+ZKUIRBxIoe4k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XMlkc+PbQa5ETvEaDAaBbmT5QX4+xv/EPQSOCAVP/L1dU9COjPefGzKlJe8jYVXna
         nYuAuH1cbw4uikZ153UwAhns3WVREbS5Re++ZejgcvoSxVC5sqiCXrSzUikx56+TS4
         28E3ViYH08cb5NYKRhIv8F5/euCVxiunAasNCCWEsoyhO36HYEkLSRZ2skugdxpUEd
         VqcnhqLlSdz8U1zBzzgNijH4/SF6jbCbxRdR19EJrqXvnHqBKRmNcrckjZ3Yv6VQkr
         k+B+n91aydOzpZz9KgpsgVFYe2zSDmhWB//uIbpdVVFP2S8CbZl2kyoFFIPN6Kw4RQ
         V8l3vD34el57g==
Message-ID: <8ee5cb41099133ca8b4be0c87c93af27b3e74e2b.camel@kernel.org>
Subject: Re: [patch net-next 1/3] net/mlx5: Expose FW version over defined
 keyword
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mlxsw@nvidia.com,
        idosch@nvidia.com
Date:   Thu, 27 May 2021 15:10:35 -0700
In-Reply-To: <20210526104509.761807-2-jiri@resnulli.us>
References: <20210526104509.761807-1-jiri@resnulli.us>
         <20210526104509.761807-2-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-05-26 at 12:45 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> To be aligned with the rest of the drivers, expose FW version under
> "fw"
> keyword in devlink dev info, in addition to the existing
> "fw.version",
> which is currently Mellanox-specific.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Acked-by: Saeed Mahameed <saeedm@nvidia.com>


