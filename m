Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD95E16577B
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 07:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgBTGU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 01:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:33524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725988AbgBTGU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Feb 2020 01:20:28 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1894120801;
        Thu, 20 Feb 2020 06:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582179628;
        bh=8IoxOxy39j/saUuYyVkPLGtFgCZKtZoR+hXw8hSmfNg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iSHs98bNofsvEVJqbNnQ1EtLN5ZUB4VMClfNNT6L7Qs3eubPoanJtL1c7FTMf47bn
         ZXziAcSTUWnF22irn0wLE9TUULvlGvsa2kq15+hkUMRaxAdipPnf/wTwWC+NbrII6/
         WHTeQKulCV2gVBoEvnMJ+IfyW3xqugfFHmQMh21w=
Date:   Wed, 19 Feb 2020 22:20:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Subject: Re: [PATCH net-next 6/7] net/mlxfw: Add reactivate flow support to
 FSM burn flow
Message-ID: <20200219222026.296b3780@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200220022502.38262-7-saeedm@mellanox.com>
References: <20200220022502.38262-1-saeedm@mellanox.com>
        <20200220022502.38262-7-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Feb 2020 02:25:55 +0000 Saeed Mahameed wrote:
> +				      "FSM component update failed, FW reactivate is not suppoerted",

supported
