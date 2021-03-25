Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12773349CFF
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 00:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhCYXoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 19:44:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54778 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231191AbhCYXnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 19:43:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E68D74D248DA2;
        Thu, 25 Mar 2021 16:43:41 -0700 (PDT)
Date:   Thu, 25 Mar 2021 16:43:37 -0700 (PDT)
Message-Id: <20210325.164337.655533532640030375.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2021-03-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210325050438.261511-1-saeed@kernel.org>
References: <20210325050438.261511-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Thu, 25 Mar 2021 16:43:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Wed, 24 Mar 2021 22:04:23 -0700

> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave/Jakub,
> 
> This series provides update to mlx5 netdev driver, mostly refactoring.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Please respin as this gives conflicts against net-next right now, thank you.
