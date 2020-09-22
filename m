Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6796273A20
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 07:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727059AbgIVFVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 01:21:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726480AbgIVFVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 01:21:45 -0400
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87B2D23A84;
        Tue, 22 Sep 2020 05:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600752104;
        bh=Bf+ehHnKw3zmEiDgeevFlDgrkhad4CEKNM9R/rerHYk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qShZ0Fyph6+SFlGOyAXa7oNoIbbS4m944QGUL6v3k+0suI+dZqYj8QZhtCu2BENrN
         s/ELDSMSac47XO8uHhh7Gcc+SduPehkNjxyRdAzyu9T4ZUAq93UxPBenxXrVITVQDa
         2ZHTdbSDJW5JaJiQtt/E9zWZEEGuS88sWeDGxjAc=
Message-ID: <422a7a25980117f95f6289dba07d998470f65c87.camel@kernel.org>
Subject: Re: [PATCH 2/2] net/mlx5e: Use kfree() to free fd->g in
 accel_fs_tcp_create_groups()
From:   Saeed Mahameed <saeed@kernel.org>
To:     Denis Efremov <efremov@linux.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Leon Romanovsky <leon@kernel.org>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 21 Sep 2020 22:21:43 -0700
In-Reply-To: <20200921162345.78097-2-efremov@linux.com>
References: <20200921162345.78097-1-efremov@linux.com>
         <20200921162345.78097-2-efremov@linux.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-09-21 at 19:23 +0300, Denis Efremov wrote:
> Memory ft->g in accel_fs_tcp_create_groups() is allocaed with
> kcalloc().
> It's excessive to free ft->g with kvfree(). Use kfree() instead.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
> 

series applied to net-next-mlx5 


