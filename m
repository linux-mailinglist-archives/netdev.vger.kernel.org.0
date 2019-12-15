Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A9211F5C2
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 05:41:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfLOElz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 23:41:55 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:46145 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfLOElz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 23:41:55 -0500
Received: by mail-pj1-f65.google.com with SMTP id z21so1493384pjq.13
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 20:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=GzqekoSsiJhHhy3QDfssxU42UV2oNZcaqEy6PK6DVjI=;
        b=LwAzx8LbAiNHAWd6OLd6fZXj2KjcurS1Z0Hl4kIbyEUvw9uW+WhOQXqSqC4k6uo8E8
         Xft2MYJ+1RUH2QJmkm+nIE/SSwepke0SadXY31Orudr4wMkJYcXy6OUElfMEWnE6khFN
         zyuDTyqD5ju1LjNaBxkwuRzMZtnc75rk+QoMyC7BcR/pSajOg7Mm1hnVeWm4tE5HRTCy
         U00F5kVfS4SeXC8L6CkhJBwYTnKI6RbInJogglE+7Ad7d+C4nnxf/zFzpIy7HW6nxiRw
         w6SdnlwVo17j3MzcZQo8q33lqSMMJ8qU6StBxUBfOtQ23HbQGnkqS3sLLPCo1HG7fjAD
         uStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=GzqekoSsiJhHhy3QDfssxU42UV2oNZcaqEy6PK6DVjI=;
        b=G4C6GLAk1WdPDOHd+Fsg0pHbwa612Rmf9x0SwTaTbPRY6WY/wPOBoV54DlHUZgNkCJ
         va5yaD/myiURJ9VQexFGt19yBFg77v9qUwYZvyBCHyDHDpjRmn6HGvaLp620S4r0hn1D
         Q73v4Fjxdw1RE9VUnv24XxzoJxA4UXWJT+YBxwgnUQ+48Z59T1sups4cjjubBsVNf6KG
         wu/ABS3sMWssnh2A0F1o+mfA7x3/5Od7O6+lTBjU5L1hUUnoJX6Svy3PNHPjlzwZPCxd
         ABTGrFKW1NYG3yUNknQ05gjRKxVSu7TBYgVlPLYY4aVXZSVz7lVFbc3e0ErtszKPhcDj
         5x6w==
X-Gm-Message-State: APjAAAU0/fd8yXSqU/1dabLzKz9eMvykn1mPtkF8d9gKRzZg76kH9AGa
        09qbi3LuB5tjgwlsB481ZNBQgxY/+0I=
X-Google-Smtp-Source: APXvYqxG4TunIjdAc0ToHNxTIhBa/LWC6oxt6HH9RfC/EfT5qzMGxTNn2Fv7Qe6niEvFbd3f3NvSyQ==
X-Received: by 2002:a17:902:7795:: with SMTP id o21mr9265788pll.64.1576384914292;
        Sat, 14 Dec 2019 20:41:54 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id u1sm16374969pfn.133.2019.12.14.20.41.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 20:41:54 -0800 (PST)
Date:   Sat, 14 Dec 2019 20:41:51 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Hurley <john.hurley@netronome.com>
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        oss-drivers@netronome.com
Subject: Re: [PATCH net-next 0/9] Add ipv6 tunnel support to NFP
Message-ID: <20191214204151.55c6e4c9@cakuba.netronome.com>
In-Reply-To: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
References: <1576174616-9738-1-git-send-email-john.hurley@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 18:16:47 +0000, John Hurley wrote:
> The following patches add support for IPv6 tunnel offload to the NFP
> driver.
> 
> Patches 1-2 do some code tidy up and prepare existing code for reuse in
> IPv6 tunnels.
> Patches 3-4 handle IPv6 tunnel decap (match) rules.
> Patches 5-8 handle encap (action) rules.
> Patch 9 adds IPv6 support to the merge and pre-tunnel rule functions.

Applied, thanks!
