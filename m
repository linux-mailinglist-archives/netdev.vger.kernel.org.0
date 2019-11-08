Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D84F5B95
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbfKHXDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:03:11 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34412 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKHXDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 18:03:11 -0500
Received: by mail-pf1-f193.google.com with SMTP id n13so5844120pff.1;
        Fri, 08 Nov 2019 15:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=bPuYIxQhdq+t8iZC1U3HtlBmgCYTOt/HYWMnJkS5gQ8=;
        b=DpX4NrCnPQekAINGsaqVrwv7tRDi/nTGbEJ6dDnmqbW2WXiFxPZFtCEjnGdoZx/2an
         jrIykiJnro0Gqu6bsN6I8GYhwd4jatJqgWisqPhpatTe+1R2jX0k+kzPe9UumjHlIZQN
         UhWIyfaLTRQeqhZ5qdAxUgf14pWDJJNRmARwDQDG9l1VV7qJsEKG4HM0cvlzwLscKvrG
         MiW6rPx3cp3paDx2p5O+dfm3oMf1uH91pNPUTeUnf0ab/W2lleNS+B+8tDBAChjD0jrI
         0JR83Q3EYDEzU7QiJMv8hNDn1tdDWUwPyMS0Qy95ZvDbWstmN7Re5uAn0rPBuYY0KVba
         bmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=bPuYIxQhdq+t8iZC1U3HtlBmgCYTOt/HYWMnJkS5gQ8=;
        b=mtPsiIcdMdyuyJObaIFHhP3RXNbY3KgAM+EF+WtK5VgXA6clemdX3luSOODZg1szBA
         71IqR+G345hQFYkfxlBr/XeP67WZAi+cfzW0BvNa59jaUsIC73DOMq9j11ceC7HEl5Hn
         q0u0wOFvC3MzvlNEJtAhvGG2Kyq2K6d2Cm9bNnWkuiYBL68RVEC+iJGZDz799YhwKgOd
         vPIMliU4TCwHAZT0oXII41mdRVk5UV7k5HF59hbP4wKJEjRTZwYM5Os09/UWCVLV8CXh
         PNyiZcER9Af7WLDaz7ARIs3aLFGyOuQ3AiiQDBeF/kSYChVOdDzNiT3e1N5NL2aos77J
         1FFA==
X-Gm-Message-State: APjAAAWXaDeTilAkCd2DoD9JscojU+Ltf/ktpFTGjye0m8fzfhoe4Soz
        b7F/Iw+0wCRzt0/+8ONEJE0=
X-Google-Smtp-Source: APXvYqyzm9GUTygSEBt8T7iRFZh9unhUkJQkDu3sDIffXdJSO7xk1Y+lcWQclinaup04ctM3mhbCaQ==
X-Received: by 2002:a17:90b:46cf:: with SMTP id jx15mr17312340pjb.19.1573254191039;
        Fri, 08 Nov 2019 15:03:11 -0800 (PST)
Received: from [172.20.40.253] ([2620:10d:c090:200::3:c214])
        by smtp.gmail.com with ESMTPSA id b18sm7184213pfi.157.2019.11.08.15.03.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 15:03:10 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, u9012063@gmail.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 5/5] xsk: extend documentation for Rx|Tx-only
 sockets and shared umems
Date:   Fri, 08 Nov 2019 15:03:10 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <7C1BBFA7-8811-46CE-BDCF-3F93F5AB1C6F@gmail.com>
In-Reply-To: <1573148860-30254-6-git-send-email-magnus.karlsson@intel.com>
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-6-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7 Nov 2019, at 9:47, Magnus Karlsson wrote:

> Add more documentation about the new Rx-only and Tx-only sockets in
> libbpf and also how libbpf can now support shared umems. Also found
> two pieces that could be improved in the text, that got fixed in this
> commit.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
