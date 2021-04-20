Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9ED53651FC
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 07:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhDTF55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 01:57:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhDTF55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 01:57:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 923CD613AB;
        Tue, 20 Apr 2021 05:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618898246;
        bh=HgRtm7l8Xx3VQolaL5PH0kiPMFdrNK/V7TAZt6MT+6Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DQgny5On523ruh0mv44PPfD47aTwlf0jGlMYZ33gSO+AcIHlL1ms5/e2kzkE0qrwB
         HNmGovIMhyjjRNRzjEhlGdXnKfYpNbVPBS9/ck4WH11i+GkGiommnJF6hJNOJsKQo0
         3N+vBdCIdgd4krGBwDmIHAWcpqszMnZuJVBQ0jL2B0Qi8OZCPb1WihatJY+H8q5zrA
         oPFxBHsqm2wX7Z67nPBBKTphUzmbO2Gp5ksz0ktAP+7Hl5SoDa/SNsav1jmgI+c0PZ
         TJH6TUQOr+22fmKJJCbux73MwBw41Wajd2iQ9St0+4Im98enWMqW6A6Y2AGDqlo8Pz
         nRY3WM3WSTVJA==
Date:   Tue, 20 Apr 2021 08:57:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2] lib: move get_task_name() from rdma
Message-ID: <YH5tQi+JXOm8LW9V@unreal>
References: <a41d23aa24bbe5b4acfc2465feca582c6e355e0d.1618839246.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a41d23aa24bbe5b4acfc2465feca582c6e355e0d.1618839246.git.aclaudi@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 03:34:58PM +0200, Andrea Claudi wrote:
> The function get_task_name() is used to get the name of a process from
> its pid, and its implementation is similar to ip/iptuntap.c:pid_name().
> 
> Move it to lib/fs.c to use a single implementation and make it easily
> reusable.
> 
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> ---
>  include/utils.h |  1 +
>  ip/iptuntap.c   | 31 +------------------------------
>  lib/fs.c        | 24 ++++++++++++++++++++++++
>  rdma/res.c      | 24 ------------------------
>  rdma/res.h      |  1 -
>  5 files changed, 26 insertions(+), 55 deletions(-)
> 

Thanks,
Acked-by: Leon Romanovsky <leonro@nvidia.com>
