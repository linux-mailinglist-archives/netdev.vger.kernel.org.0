Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C59D016B87C
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgBYEUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:20:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728846AbgBYEUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 23:20:53 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056D02467A;
        Tue, 25 Feb 2020 04:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582604453;
        bh=ju9ZgC/bC81y+HpFHVccRg408tJJO8dd8IYKODBYGkw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0RvQ5Nrq6EJm4rFsLZFvDMlF5V+9dt3DY7llEE1smfP3kOoxa466LLHxS09eAWlxK
         9/NjaNc+0okco5L2g4zxCBdjWD23eZEtqm1cLf9aVAi99QK9AWsnDtADgxhsuQJ9uP
         T52vpmwQuBXWHdc/cwwTtaTeF+8aZl0fOjy2TsLI=
Date:   Mon, 24 Feb 2020 20:20:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 04/10] devlink: extend devlink_trap_report() to
 accept cookie and pass
Message-ID: <20200224202052.1d2ff3cc@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200224210758.18481-5-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
        <20200224210758.18481-5-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 22:07:52 +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Add cookie argument to devlink_trap_report() allowing driver to pass in
> the user cookie. Pass on the cookie down to drop monitor code.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
