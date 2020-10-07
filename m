Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 317162868A9
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 21:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgJGTyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 15:54:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:36480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728522AbgJGTyP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 15:54:15 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A54B206F4;
        Wed,  7 Oct 2020 19:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602100455;
        bh=m/Ju4SAFkISJTuC2HSUsBs3/OEqHxcbynuVztu+8kMY=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=zSjtUQA4LdCfZ59kMYsU9C6Xxr/ajtxKskoTlc5EvykO9HNdqEZwCP0qE/E3435DL
         kKREuKMcjyV6SeGvqm6zZWUQ22ULZHn1WHiHlp7NQVxK78jmOo7UDIU2RnYSYWWVtv
         TZ3nyesRBD5Fb2Zuxc48JYhjcDiuwoM7k/tjM59c=
Message-ID: <35c7056a150946acedcc99d3b83f340305ac1254.camel@kernel.org>
Subject: Re: [PATCH] vdpa/mlx5: Fix dependency on MLX5_CORE
From:   Saeed Mahameed <saeed@kernel.org>
To:     Eli Cohen <elic@nvidia.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date:   Wed, 07 Oct 2020 12:54:12 -0700
In-Reply-To: <20201007064011.GA50074@mtl-vdi-166.wap.labs.mlnx>
References: <20201007064011.GA50074@mtl-vdi-166.wap.labs.mlnx>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-10-07 at 09:40 +0300, Eli Cohen wrote:
> Remove propmt for selecting MLX5_VDPA by the user and modify
> MLX5_VDPA_NET to select MLX5_VDPA. Also modify MLX5_VDPA_NET to
> depend
> on mlx5_core.
> 
> This fixes an issue where configuration sets 'y' for MLX5_VDPA_NET
> while
> MLX5_CORE is compiled as a module causing link errors.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5
> device")s
> Signed-off-by: Eli Cohen <elic@nvidia.com>

Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>


