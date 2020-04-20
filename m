Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCB651B0239
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 09:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgDTHGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 03:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725815AbgDTHGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 03:06:45 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A5CC061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 00:06:45 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id a2so3280291oia.11
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 00:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pCKv38QqOc3KeqRBzcElFqmdtcE90GfK2tcNEFNDP5E=;
        b=YIrvJqTq9mDXcDElHClH4DMSAk3XzKOxlxK4DQUNIdWHSzfNYJWuFYknuwnJsjG2EL
         KCF3U0+w5Limmi8UhRCyDnfDuGdmLDYz9SKKT6yWOyzSCqcwFZ1cky8HhqbxTCVqppT7
         4YNqdN+iaWJjdUaV+B10y9S5/WQ0J2fGervw1Jf2Ot5w0gBSThwSsJysCGd1Uim5sAl0
         36/EBV++E9v20nzLqO4aUQ0RJx5tTihxiAFhRjwltNdkBTs+V/vCYaKnE8gfrwa+mSw2
         m0KSqEu2z6A5WpbQieN/GA/rCRzLIcxHl4M2gZNsJbzeR3BL9kKRUtq42bhWvBsDY4QY
         4gWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pCKv38QqOc3KeqRBzcElFqmdtcE90GfK2tcNEFNDP5E=;
        b=IwnHQPwNSYf1JYrEVJKsRj7yfQdaBfxnT7r10v0PmUal3jTq+0n9koi8irFH2DUVv5
         sjzNmlCXZ1heaTOVhxmJkVDczIe0pT8Qhny9y/QhohVeY4Mzs5JK4GH5+d8N18IbW0ej
         WWyho6WvZWVMz+P/hn2c6TBTozOkMDTGlZYO2wuRswoY5E0EdcYOt2d40FwICMzpjlfG
         xXWIkNXn7fLwuVbHhCETuY14Vtb/YSWIa6OEj06/LcULCi6rluPSQke0txOOahpo25YX
         znFNrOkFZwHPy3SNiu00RquK+vq3bY4si29lsxP3NFvDttBXzKuqj0HpZhNu4plVY0Ag
         hF5g==
X-Gm-Message-State: AGi0PuZmulNbtd4wg9+4e5yCuhekE6hIp5wOQqIsgJ1gFZ+PJjVEzjjK
        jl4PXrQ5Agr4XW+/QTaVJpCmmKhvLVdtvEXLGWjGSAtr
X-Google-Smtp-Source: APiQypIBfPb3vrRzGzrqq6lKu6V0K+2xnPxMLTfPjH4D1RpJ2O3tPVKu5b3L93FHJwo5uAYtZs9ZIPkUE4mGHKHtpkY=
X-Received: by 2002:aca:e08a:: with SMTP id x132mr9663708oig.93.1587366404735;
 Mon, 20 Apr 2020 00:06:44 -0700 (PDT)
MIME-Version: 1.0
References: <CANTwqXAak_=JJqptqSjqQQU28yMbrrKJ7E=a2Vfwqoh8XdTDuw@mail.gmail.com>
In-Reply-To: <CANTwqXAak_=JJqptqSjqQQU28yMbrrKJ7E=a2Vfwqoh8XdTDuw@mail.gmail.com>
From:   =?UTF-8?B?5Lq/5LiA?= <teroincn@gmail.com>
Date:   Mon, 20 Apr 2020 15:06:33 +0800
Message-ID: <CANTwqXB6cN3OH48JLOfiPORDqFOATWGK7A0aSo1fODDC9EQsbA@mail.gmail.com>
Subject: =?UTF-8?Q?Fwd=3A_drivers=EF=BC=9A_target=EF=BC=9A_iscsi=3A_cxgbit=3A_is_there_ex?=
        =?UTF-8?Q?ist_a_memleak_in_cxgbit=5Fcreate=5Fserver4=3F?=
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, all:
When reviewing code of cxgbit_create_server4, what if
cxgb4_create_server return a  >0 value, the cnp reference wouldn't be
released. Or, when cxgb4_create_server  return >0 value, cnp has been
released somewhere.

static int
cxgbit_create_server4(struct cxgbit_device *cdev, unsigned int stid,
     struct cxgbit_np *cnp)
{
     struct sockaddr_in *sin = (struct sockaddr_in *)
                                         &cnp->com.local_addr;
    int ret;

    pr_debug("%s: dev = %s; stid = %u; sin_port = %u\n",
                    __func__, cdev->lldi.ports[0]->name, stid, sin->sin_port);

    cxgbit_get_cnp(cnp);
    cxgbit_init_wr_wait(&cnp->com.wr_wait);

    ret = cxgb4_create_server(cdev->lldi.ports[0],
                                               stid, sin->sin_addr.s_addr,
                                               sin->sin_port, 0,
                                               cdev->lldi.rxq_ids[0]);
    if (!ret)
        ret = cxgbit_wait_for_reply(cdev,    &cnp->com.wr_wait,
                                                    0, 10, __func__);
    else if (ret > 0)
           ret = net_xmit_errno(ret);
    else
           cxgbit_put_cnp(cnp);

    if (ret)
           pr_err("create server failed err %d stid %d laddr %pI4 lport %d\n",
                     ret, stid, &sin->sin_addr, ntohs(sin->sin_port));
    return ret;
}
