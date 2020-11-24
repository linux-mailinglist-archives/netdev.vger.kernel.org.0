Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD4E2C19F3
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 01:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729325AbgKXA0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 19:26:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:39632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729299AbgKXA0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 19:26:41 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76DB320729;
        Tue, 24 Nov 2020 00:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606177600;
        bh=WXIqWDgfwfSgFlM60ucFJzcL3gUNdU0FIdf0MVwQS10=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZGD6pXauuInRUOUYulE9u2R6qQml9sZ5cXFM/ClgJmwlAECkvKN1BlpvF+N2jIOKd
         1lAzdvCY/A/y9UddzEwO9+Oph7zi4kR++PRDPDmBlF5+CpYQW/n/2YG138EH2+f84M
         Nsw7GxvAy9G0I8EhqSuAzg8DNQYgsMQMBEpTkaoY=
Date:   Mon, 23 Nov 2020 16:26:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Limin Wang <lwang.nbl@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: LRO: creating vlan subports affects parent port's LRO settings
Message-ID: <20201123162639.5d692198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACpdL32SRKb8hXzuF_APybip+hyxkXRYoxCW_OMhn0odRSQKuw@mail.gmail.com>
References: <CACpdL32SRKb8hXzuF_APybip+hyxkXRYoxCW_OMhn0odRSQKuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 20:37:27 -0500 Limin Wang wrote:
> Under relatively recent kernels (v4.4+), creating a vlan subport on a
> LRO supported parent NIC may turn LRO off on the parent port and
> further render its LRO feature practically unchangeable.

That does sound like an oversight in commit fd867d51f889 ("net/core:
generic support for disabling netdev features down stack").

Are you able to create a patch to fix this?
