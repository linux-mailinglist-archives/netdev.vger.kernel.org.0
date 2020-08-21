Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EED24E0A9
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 21:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgHUTal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 15:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgHUTak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 15:30:40 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB07C061573;
        Fri, 21 Aug 2020 12:30:40 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id t6so3051867ljk.9;
        Fri, 21 Aug 2020 12:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qH5V/CAcJojJmrzaRt7ZuBu4tS92/jfWcHTajZqiiyI=;
        b=nXa4dnmh56UCe81eiSlJuACzhYWGLwTPW0cWew3TjOI3GBAxXlIaKhWXArxV3Olp/J
         Qfv/v9oJoWIAf3TdvcRENmdXWbO0QKQby42iwqtRPSXPL8XF18hGu1np0kf4qDCm3rFm
         1qqLluYHbwjsH0It5tyK6o3ZwfopCd40i1UZkA0FcmO2QoO2etRgSja71OdK7nalf4II
         FOKiQ8vQSg2nCSoZAk8gMMxnKEYTELrWAw1FM4BaT4YGK3my3HKSboQ9MQn0zWO0gEgt
         wHMIrK6eM+zAWd1Vak9iJv9Sd3er4oTcGp7BIrdo1wbUl4xbhfWYOFZWb4YaURtit6Yk
         ufZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qH5V/CAcJojJmrzaRt7ZuBu4tS92/jfWcHTajZqiiyI=;
        b=KVq+LAS9TLtKL4PV5pFz2UCgzkcLr2zGpXu826sIiyPRrRQPX16t76hpXM8Gqkk9Bf
         UzhpN6YPON7Mp8xpYEYhX+U2gAKz4eRn4H5qu1duG7thmww8vxfcCSvffdGid0cOJLeL
         QDgh9ZSQbrfM+TeOLnZUqXGjquiQBuj2gY2xfmGkoptyj2Q1LJjdVtkYQSeL5IeKUTW/
         GjYImuyAh4AbVseTS1lGYS98FGr/JeImpDn59NJi284qkezA61L4dbh0eZjyGt4qtnuj
         kVL5GEEtiLYR8LWjGDASzpgT4qISFw5ycTXl/YwF2tcboMMbGZ1f03oAyTGI9STounWw
         tH0w==
X-Gm-Message-State: AOAM532seQti42T0yL6mfDz5jbVguOndmPHbzQzhBcZHDGc8X19BI2mp
        eerWb072imL8vhrxxNo2nFI7CqzBZ1FSKWcWk40=
X-Google-Smtp-Source: ABdhPJwMOif6Xh8+WCxYlHVKVqV2ZWk8p7B9yM6GPYXiD0wSQMJyAQ1zBXPkdkfYQ19A2wlN7RlXiAx8pd8/pAYWbxQ=
X-Received: by 2002:a2e:a489:: with SMTP id h9mr2251463lji.121.1598038238500;
 Fri, 21 Aug 2020 12:30:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200821133642.18870-1-tklauser@distanz.ch>
In-Reply-To: <20200821133642.18870-1-tklauser@distanz.ch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 21 Aug 2020 12:30:27 -0700
Message-ID: <CAADnVQKL3V3bDrMZSb_ksiLtH0wLXY7L8ueo4eBgSY8TgLx21g@mail.gmail.com>
Subject: Re: [PATCH] bpf: fix two typos in uapi/linux/bpf.h
To:     Tobias Klauser <tklauser@distanz.ch>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 21, 2020 at 6:36 AM Tobias Klauser <tklauser@distanz.ch> wrote:
>
> Also remove trailing whitespaces in bpf_skb_get_tunnel_key example code.
>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Applied to bpf tree. Thanks
Please include destination tree in the subject line next time.
