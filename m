Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42CC83718CF
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 18:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbhECQBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 12:01:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:57694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230236AbhECQBy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 12:01:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDC5C610C8;
        Mon,  3 May 2021 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620057661;
        bh=eFF+9oVQIfj0S7SWiQi7jyzho6vchOyVKUT2sxsr98k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sJz945kPo7MYfVFkg3QlYqsNa8vk6v4hqdthp3qqmUlZVRHarBfnwVQkXFJ2Xn6jV
         myWMvy5yD5ltlDhJ504Mo+HQB6+Uqv4YEon3O5Q/FwXL2BCEIKMRKbs7k6B3bUlnCR
         JOHHrM4Pdx89l+L12gLfhacgV1YO7+haIkrXHsjv5v8opskSuilaRyIpvY/QVLOBnt
         w9oRJSHRXsC+U9Z5e31rCE/v6ilySX4CvNaf3qr5weWc2JIqnOoC58fExUZ217x89u
         gvPlmKA+UUomyAqrsno/3rqYAv6Ztv72UPT9l3aa9jht7Cr5iC4pW5F9kdxQOOpQCI
         njf7p7y3jw+Fw==
Date:   Mon, 3 May 2021 09:00:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PACTH iproute2-next] ip: dynamically size columns when
 printing stats
Message-ID: <20210503090059.2cea3840@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210503075739.46654252@hermes.local>
References: <20210501031059.529906-1-kuba@kernel.org>
        <20210503075739.46654252@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 May 2021 07:57:39 -0700 Stephen Hemminger wrote:
> Maybe good time to refactor the code to make it table driven rather
> than individual statistic items.

=F0=9F=A4=94 should be doable.

Can I do it on top or before making the change to the columns?
