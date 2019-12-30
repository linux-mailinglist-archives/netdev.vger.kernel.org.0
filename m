Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9F212CD0C
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 06:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfL3FtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 00:49:10 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60860 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727142AbfL3FtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Dec 2019 00:49:10 -0500
Received: from [192.168.9.205] (157-131-199-19.fiber.dynamic.sonic.net [157.131.199.19])
        (authenticated bits=0)
        (User authenticated as andersk@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xBU5mscK010955
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT);
        Mon, 30 Dec 2019 00:48:57 -0500
Subject: Re: [PATCH AUTOSEL 5.4 056/187] Revert "iwlwifi: assign directly to
 iwl_trans->cfg in QuZ detection"
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20191227174055.4923-1-sashal@kernel.org>
 <20191227174055.4923-56-sashal@kernel.org>
From:   Anders Kaseorg <andersk@mit.edu>
Message-ID: <5dbea7a0-5c66-abe4-b1ef-bbfceccbb9bb@mit.edu>
Date:   Sun, 29 Dec 2019 21:48:53 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191227174055.4923-56-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/27/19 9:38 AM, Sasha Levin wrote:
> From: Anders Kaseorg <andersk@mit.edu>
> 
> [ Upstream commit db5cce1afc8d2475d2c1c37c2a8267dd0e151526 ]
> 
> This reverts commit 968dcfb4905245dc64d65312c0d17692fa087b99.
> 
> Both that commit and commit 809805a820c6445f7a701ded24fdc6bbc841d1e4
> attempted to fix the same bug (dead assignments to the local variable
> cfg), but they did so in incompatible ways. When they were both merged,
> independently of each other, the combination actually caused the bug to
> reappear, leading to a firmware crash on boot for some cards.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=205719
> 
> Signed-off-by: Anders Kaseorg <andersk@mit.edu>
> Acked-by: Luca Coelho <luciano.coelho@intel.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This commit’s child 0df36b90c47d93295b7e393da2d961b2f3b6cde4 (part of
the same bug 205719) is now enqueued for v5.4, but this one doesn’t seem
to have made it yet, perhaps because I forgot to Cc: stable@ in the
commit message.  Can someone make sure this goes to v5.4 as well?  Luca
previously nominated it for v5.4 here:

https://patchwork.kernel.org/patch/11269985/#23032785

Anders
