Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED996B149
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388078AbfGPVnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:43:10 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:45415 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfGPVnJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:43:09 -0400
Received: by mail-pf1-f170.google.com with SMTP id r1so9725716pfq.12
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 14:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v5xj1gm61uNMHXaOwR7ModT8QrdTvP4wvic8yErvY7g=;
        b=HEKhekz8YFi7Pv/UVrVWEJ/MqUcViPEzVOq7HmkMD214m4nWGaAjC6xwnuM7vgOJrS
         6xSOETpFkS76LWhBa0qX8q2SZJlJbPD0Gr69AcK7Iyr8OUDi++0yly5Ovi29y0lvEDdk
         ahrbjnFgcD1Iz1sTygElPeQPNDjKrcvB+6s5Q6+pa42AN+UiO7jrRXuV3obAxT2icFCG
         nxBZgS7wWs8k5F7zk9tdTtDLLNGfO3fdoRHFMFjj5qkdO9ELQs5w9bsB2TND4Sq/zFUx
         76Bfx4H9jvb+TQ3rSlEavnlj38tbr+Qm8ijtpXT6etTfZ6w8MENA6ecV4jTa+MKV0h10
         cKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v5xj1gm61uNMHXaOwR7ModT8QrdTvP4wvic8yErvY7g=;
        b=FJnLU8fc+enSqAt0+HtOzn7+jcOIiF2nIksI4TsxylqXROpgB6KhVKFdnzWG1tYKmJ
         F6/VWGPk8K1drwN0euZlp1DcqrMr/nVwAfG1YZEGC87fl7xHSLNmvxiW4KtV5q9DGJH4
         uK+OOlWRLW/3wNI6M57eyIxWS+C76PErG8pr7fTh7EdbjLo0iGRD65g2/nMfyqn0f1ME
         fQcZ+JWdABIBDoVuQYqeLsGRS2V8bfVTA5ESWgMamLaBeFAWWY90rwrxnvi8/upg95IF
         M3hLBXPxxZBVqVzECuJjsRFF9QruxqQQL5BxemY1xAzbIuSBnhq1qM1SUtXvkDou0gCY
         ATgA==
X-Gm-Message-State: APjAAAX+Ym1ra9E7DRVq0UHylY884ORa/zRzwHJK/A5qQBky2H2vybeP
        VGPrTFMhqNkjIWin+BjJpfxULGSw/YhpEq+teaJ9zijH
X-Google-Smtp-Source: APXvYqyJf/npe2n1RFijIaxFsQyU1GYhkdNnHh1a89fQNwh1aV78GWjRgMGfX1sg0+2im+oYETq6nemFzSldc612fkk=
X-Received: by 2002:a17:90b:94:: with SMTP id bb20mr40000139pjb.16.1563313388894;
 Tue, 16 Jul 2019 14:43:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190716205804.19775-2-xiyou.wangcong@gmail.com>
In-Reply-To: <20190716205804.19775-2-xiyou.wangcong@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 16 Jul 2019 14:42:57 -0700
Message-ID: <CAM_iQpWJArgRdBttjBqckdzP=L6A69PggLEeCS_mUAPwm+2TxA@mail.gmail.com>
Subject: Re: [Patch net v2 2/2] selftests: add a test case for rp filter
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 1:58 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> Add a test case to simulate the loopback packet case fixed
> in the previous patch.

Well, I actually have to create a dummy1 to simulate it, as dummy0
is the gateway interface assigned to an IP address.

I will send v3.

Thanks.
