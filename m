Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D318035D039
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236673AbhDLSXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:23:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229666AbhDLSXn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 14:23:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E11C36109E;
        Mon, 12 Apr 2021 18:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618251805;
        bh=K7a1pfEYYk/pioVLPnc0E6Q6x3bOQiu6b2+8PYqRSuw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fHY0sSP6ksOWaqmHjhiG9X9nwQ7LZs1bawAV7Du2Cp//JBVg9mlx2RjeRS65jRwYg
         TQ9F1Ec6mzSidWAs7HRVu4rUJOSotmacxtsZVH0vv5WdTaQ20lXsgnZAYi817S3i8z
         /F/udTxgNt4GFq7C3QqoajuKSJlY4+rE2vT3KQArIidtBqNxPoVfuEyUQjUT3Fr0m2
         f+pEvbkE4JIRGcjQ8M9BbBPZxT5lhsM3qtyzQ+Ett1ADC51oXPT2pQpuWIHuWBAYSJ
         IMRcCu2oFb3VA7NhPs/KrsxBZ7HUec5vrb3AKIeiwYkrPsEr7bN+qsnQbT+ft80b3H
         KGetlC2W4PyBg==
Date:   Mon, 12 Apr 2021 11:23:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ibmvnic: add sysfs entry for timeout and
 fatal reset
Message-ID: <20210412112323.26afa89c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210412074330.9371-3-lijunp213@gmail.com>
References: <20210412074330.9371-1-lijunp213@gmail.com>
        <20210412074330.9371-3-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 12 Apr 2021 02:43:30 -0500 Lijun Pan wrote:
> Add timeout and fatal reset sysfs entries so that both functions
> can be triggered manually the tested. Otherwise, you have to run
> the program for enough time and check both randomly generated
> resets in the long long log.

This looks more suitable for debugfs.

But can't you use ethtool or devlink reset functionality somehow?
