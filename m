Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B3B306782
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 00:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234432AbhA0XF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 18:05:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:40404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234163AbhA0XDr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 18:03:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7FCF60C3D;
        Wed, 27 Jan 2021 23:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611788585;
        bh=MDmEBaWw3IAdiV+yl/lHanIeaIO0v8UbrTCeWeW1oBI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Df+n+7UJSQJDFVvkNveHDtVd+7opBmaD5euXpBfrIHuTHQ+97Y024/1IO17pw08tY
         wQkyC/BOH96gahrfA5CzDh16m/Gf3md64KfNVU4C7os5Eq85UviKrgfTJ5xvQgrDzL
         mnPNxuRNpynUCbkEK6ZuHK9bfG7QW9LghtDAEU2haibDiiPqYSKXeeE6LRvgd5dUBf
         nv0t2OR1tH+d3vfGgcBbFqFEzpN+lVfBEzF/zFljqjd0v/lauHJEftUhgakfnmLj21
         mzy7ZVIul+o5GvKmA5MGDsKIQ/w1uWg59FRBgNo8pc5quWJcA2FP+duALR7G3P6DvP
         R5CRXyhALOOBg==
Message-ID: <66cb9c747a98e911d71187332683e1bb548a6c44.camel@kernel.org>
Subject: Re: [PATCH net-next] net: psample: Introduce stubs to remove NIC
 driver dependency
From:   Saeed Mahameed <saeed@kernel.org>
To:     Chris Mi <cmi@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com
Date:   Wed, 27 Jan 2021 15:03:04 -0800
In-Reply-To: <0837f7ce-cdb9-fe3e-ac10-acfc3e35ee30@nvidia.com>
References: <20210126145929.7404-1-cmi@nvidia.com>
         <20210126184955.5f61784a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <0837f7ce-cdb9-fe3e-ac10-acfc3e35ee30@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-01-27 at 11:42 +0800, Chris Mi wrote:

> Could you please tell me what's sparse warnings you hit?

https://patchwork.kernel.org/project/netdevbpf/patch/20210127101648.513562-1-cmi@nvidia.com/

build allmodconfig and build32



