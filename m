Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98600108651
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 02:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbfKYB3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 20:29:35 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:37933 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727072AbfKYB3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 20:29:35 -0500
Received: by mail-lj1-f170.google.com with SMTP id k8so3255602ljh.5;
        Sun, 24 Nov 2019 17:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=EnpVr9gg7gkumYCQnOKkv4m/WBcUuib8Eyj+epJNIWk=;
        b=guqFZ7AwBudO+N1SZbsvh/8zWVlenHmUFGppmhoM7s533Vo8nxdFh7qfnXxeQ1UqpL
         SvullyxUAU/wtmtrQj0Snpe3i8jPPUZHSqqI6P6jHJuY+nwr8f9g0cEp/cWEoNQNxiGg
         QS1N6ZD4Op73RWEVEVBcvS0JM80xlTmcK4f/P6sBU6XuCVXb6c3EO7joqEUrvDi6gF6N
         sNw7HbkoyOL4A+RzDiXdCTAc3UxOfg+CgESkTuiDQefOh0YHhJG3tN4XrHpO3kYvN54B
         Z2AekSw1Ha2Y/I5z1xqvywBOqM4GjZipKU8WCGyq1BotSvOs5Nw7C4oQ7+b0UHA8VHRW
         zaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=EnpVr9gg7gkumYCQnOKkv4m/WBcUuib8Eyj+epJNIWk=;
        b=cpshynZ36KzgDiXuf2tbu1KzSTu5Bn81I7ze4NHjaKgtV4qS1HbtPn4EAZE6hAq6wF
         SEYwUAtfWa757r0a+KvZvtDvfYURuQoIg63ocwGkY/3DQ7t1C8UIqyikjEaOrmoHSKWP
         ym/XCXEKXUOTBxARxdiI9AgrtvhMr8HHCeZgZwvWhDc6TdbPeoJKvj0T9RTntvrCEZFG
         j/yfF84Mbij332lQTxv7VkO62bh443Nq8dFQTaqsoqBro0brDtuogUhJz+WaT/HUZdKf
         nNLhKElA1iPOJmwT6qDcPDXub1z8y08FEbz5PD4/6l4F5/CZpFOhdhSxRJcKPJjq5Avv
         T+4g==
X-Gm-Message-State: APjAAAXoardc/JQRTolS23hhdoBLTun3LPgYWXoxT7WdKLTv3lf5BZ+1
        6PhQyIUg+tj+Jtzxj2N/C2cx12/duQeyHV8XeV0Jeg==
X-Google-Smtp-Source: APXvYqyFtc3IssHJW8DUkrujTV9CR8MoJf1IockvaPaP5fQIvGnrbrjG/uxzcKNEOyZNZ6oJtR4eWICZZ5HE6Fvwo/c=
X-Received: by 2002:a2e:8508:: with SMTP id j8mr19937200lji.136.1574645373016;
 Sun, 24 Nov 2019 17:29:33 -0800 (PST)
MIME-Version: 1.0
References: <7e44b633-4a3a-e4f0-3437-f2d8e5452cf9@iogearbox.net>
In-Reply-To: <7e44b633-4a3a-e4f0-3437-f2d8e5452cf9@iogearbox.net>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 24 Nov 2019 17:29:21 -0800
Message-ID: <CAADnVQJM2+tRs5h7Z=sLXZeuw6y+aUNG78BnMo_winuBpip5Sg@mail.gmail.com>
Subject: bpf-next is CLOSED
To:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The merge window is open. Please send bug fixes only.
bpf tree is completely frozen for the next 2 weeks.
Please target your fixes to bpf-next tree.
Thanks!
