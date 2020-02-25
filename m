Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6DC16EDD6
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 19:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbgBYSU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 13:20:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgBYSU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 13:20:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1763120CC7;
        Tue, 25 Feb 2020 18:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582654827;
        bh=EweU7lP7sFmIJ4wj/qeHfMWY/185edHwn/OdB805XT4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CcFcCW6f2k8O0QXWBhult6GxXctQmyM0Gao4tr3xMkI8m6dY/mxbLbOwITSeLBKzP
         35K73U5ii0IrhvbPClNuGh1959ivwc4vDO77J4x1JVTcks0wFzepsc/rQfqp52PPtk
         03UwJofIq9hc0I7yCKg0UDqH6Gi3ZbBEh5XFPThU=
Date:   Tue, 25 Feb 2020 10:20:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v2 01/10] flow_offload: pass action cookie
 through offload structures
Message-ID: <20200225102025.1e7a8350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200225104527.2849-2-jiri@resnulli.us>
References: <20200225104527.2849-1-jiri@resnulli.us>
        <20200225104527.2849-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 11:45:18 +0100 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Extend struct flow_action_entry in order to hold TC action cookie
> specified by user inserting the action.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
