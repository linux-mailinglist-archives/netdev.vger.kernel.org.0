Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E979445CC8
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 00:55:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhKDX6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 19:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229725AbhKDX6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 19:58:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1111761245;
        Thu,  4 Nov 2021 23:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636070133;
        bh=LjZJ+WVEgGR0lT5HwCCp4cTyjDkgI7NjMus+P1YMzR4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P91c0cNKoikNJTuqnR72z8TuKfPm+tctHmEPOSqUo6EbAcv51L0xk6+ch6MXk2OfO
         Agt1V+m2lSh2nABHkw7UE/8iajNJ98AlhXmKYEd2oV9wMpB+u7QMGAWRwepzBwuAZk
         JQzLv5yk4jEgWXXNRkvQ/+pgC15Ky5AY0GavoFKmNxcADQNGJq9E+Ysbk8bjdACfP2
         17ZVw0QPnTM6mXQOyMbIjQg/dJwBdHDLow8ndmS4fwLZRH9sLounnOCjasG6cug2DG
         idsZ3EV1HEVba0OLT4IvQ8XiC+kPNSPJIk1qzo9cl9QzNQx+dkq60Gy6WCH5VImRe1
         7XB7bad+pp9rg==
Date:   Thu, 4 Nov 2021 16:55:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eugene Syromiatnikov <esyr@redhat.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/2] MCTP sockaddr padding
 check/initialisation fixup
Message-ID: <20211104165532.781b3dd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1635965993.git.esyr@redhat.com>
References: <cover.1635965993.git.esyr@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Nov 2021 20:09:36 +0100 Eugene Syromiatnikov wrote:
> This pair of patches introduces checks for padding fields of struct
> sockaddr_mctp/sockaddr_mctp_ext to ease their re-use for possible
> extensions in the future;  as well as zeroing of these fields
> in the respective sockaddr filling routines.  While the first commit
> is definitely an ABI breakage, it is proposed in hopes that the change
> is made soon enough (the interface appeared only in Linux 5.15)
> to avoid affecting any existing user space.

Seems reasonable, Jeremy can you send an ack?
