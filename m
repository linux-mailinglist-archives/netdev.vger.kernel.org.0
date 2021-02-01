Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D574D30B256
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhBAVx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:53:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:55194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhBAVx2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 16:53:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5EC7964D92;
        Mon,  1 Feb 2021 21:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612216367;
        bh=dI+duL9/FEsTm2wRTnz6YEMy2lO4CZNiyQWtyVbZQM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hZ+BYXJ9KK9LiNqDgKRE6ZHt/I5D70Qp/uoTc3grzrAKHQb7v83EksqjitIXZ8UJq
         0bOtuWH/KoW+atoLQNmP1PG5mAycgCntHDt0dMamIbXJvhLhpLqGMNXk60/vzCBNAL
         tJelgJJ08yrs+QxYZqkBtNZIM7QekabvQg41wdUoBvViuSoAKRWrRARovy5QEJ0FrG
         wm0pQttj+RV9z3z9n+qmfEtcEsTf08aBvaZ4Fk8O0xXX1jeNLlVTpsf/L0W+j+zS1m
         grg0RZZuosemxlFT6aIZI/01i4kZkDQGOLchhO323Sm9w3pIQpkLNFUpxbtdFlA2Rv
         C484oMBcjvDcw==
Date:   Mon, 1 Feb 2021 13:52:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>
Cc:     Aichun Li <liaichun@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <rose.chen@huawei.com>
Subject: Re: [PATCH net v2]bonding: check port and aggregator when select
Message-ID: <20210201135246.3610d241@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210128082034.866-1-liaichun@huawei.com>
References: <20210128082034.866-1-liaichun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jan 2021 16:20:34 +0800 Aichun Li wrote:
> When the network service is repeatedly restarted in 802.3ad, there is a low
>  probability that oops occurs.
> Test commands:systemctl restart network

Jay, others, any thoughts?
