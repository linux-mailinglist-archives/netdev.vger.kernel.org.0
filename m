Return-Path: <netdev+bounces-9651-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CF2172A1C6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B2D42819A5
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C66220994;
	Fri,  9 Jun 2023 18:04:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C561993B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:04:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D031C433EF;
	Fri,  9 Jun 2023 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686333845;
	bh=69i6su08hjzDQuT4zNtPkfXN42ckwTfhylQbdpR7/Nc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OblKa05hJLIxowkzBb38I1PhY8XmlmmyL9n6fBk0nebTNIgV4mfml78zL+DiTrkO3
	 H1RaLaNddbrrVpKZ1/5zcsPW4XJE1oUGayY79K54mGgRTY4eQkwKuQZDCGcREEgZkP
	 sA06zC3Gi/LD2M8d8abciaZK2ESWBSJ2nFJ/K3yFxwpiKdIlF9l65yBiGsQMRXZ6/x
	 JMGles1Mo+uCrwe+a1EpbsNn7evQl5yAfZLKB3YqlgRND8ZA0Byt3NmIxX3GRIeNOl
	 EIqaI8/PRP98AzjVIOhd6LJavuUR7ymVHdP5O6tR/Q70bgMgpiqiHd5sqYF8ZkLEqo
	 M6rpQLUbBOqqg==
Date: Fri, 9 Jun 2023 11:04:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Yang Li <yang.lee@linux.alibaba.com>, simon.horman@corigine.com,
 davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH net-next 3/3] tools: ynl: Remove duplicated include in
 devlink-user.c
Message-ID: <20230609110404.5a751401@kernel.org>
In-Reply-To: <ZIMPLYi/xRih+DlC@nanopsycho>
References: <20230609085249.131071-1-yang.lee@linux.alibaba.com>
	<ZIMPLYi/xRih+DlC@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jun 2023 13:38:21 +0200 Jiri Pirko wrote:
> You are patching generated file, as the path suggests.
> See what the file header says:
> /* Do not edit directly, auto-generated from: */
> /*      Documentation/netlink/specs/devlink.yaml */

And the full fix is already on the list :(
https://lore.kernel.org/all/20230608211200.1247213-2-kuba@kernel.org/
Reverted...

