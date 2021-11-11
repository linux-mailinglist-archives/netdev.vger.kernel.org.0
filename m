Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF0944DB5B
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 18:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbhKKR7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 12:59:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233987AbhKKR7W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 12:59:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E9E561264;
        Thu, 11 Nov 2021 17:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636653393;
        bh=FQRs7xMbd/K3ZCZNOTV+JxpQfdeTBc2U+I2xy6sR8o8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c4D0BG6FrBbMQiyREViq5bmJxZfsbbzK35gJDCS9ktdt/Op4bK9K0o0Pxr/SBWs3G
         fZTHWJwAjzEHNxAD9C5AKlFHLd25N/6MjboKU2RfyOy49Jh9U1vb5BybcYhVfuTN9p
         RtcOpisuAs0f1tc9M/YVzEuZ66WcuC7a++1zt5OcLEJlkUINyz9teWcY4Y0hudZFKO
         NpcGOyBztClYSFFJL2RRXddM+ofn34E+mb58TJw7guYKJiQprpfLEyiYzab2K209xB
         kChq7cZlTvQu7Unipi7Av/ry1fPyuF3rb9ACaRpti/6W+Mrb8MVTg3w+W58KsfeUFK
         RO5yITKQ5HPEQ==
Date:   Thu, 11 Nov 2021 09:56:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Mikhalitsyn <alexander@mihalicyn.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
Message-ID: <20211111095632.40e80062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJqdLrrY9zfk_i3fUhCORY33xpFPX8k4ZKWkVsL2D8sPMnNEZw@mail.gmail.com>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
        <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
        <20211111094837.55937988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJqdLrrY9zfk_i3fUhCORY33xpFPX8k4ZKWkVsL2D8sPMnNEZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 20:51:20 +0300 Alexander Mikhalitsyn wrote:
> Thanks for your attention to the patch. Sure, I will do it.
> 
> Please, let me know, what do you think about RTNH_F_OFFLOAD,
> RTNH_F_TRAP flags? Don't we need to prohibit it too?

Looks like an omission indeed but I'll let Dave and Ido comment.

Reminder: please don't top post on the ML.
