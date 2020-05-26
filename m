Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D714E1E20D2
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 13:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgEZLXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 07:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgEZLXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 07:23:12 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE21DC03E97E
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 04:23:11 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id x23so18352324oic.3
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 04:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=yZ72/ZRga4sP6om7onH6tGWgYIV/O0JzzYeCcRM9u0I=;
        b=lW9tvbKnSHb4DndBbVCuQ5itazGo5C804LxLlbzgBxS5skssav6HGAAfJ6cw9ED848
         WJ/J4+fn4PriIA2uwnD51SFQogLGSWd21o3fyNllpkaOwcf4OI2ks37Bs/K57ggzK1zF
         ogXrm9mLYO4Vm28Qskp+UqWfqK3FqlvYynPeMrIRKhxc2FRlwOua7exEo81E2nwRtuHe
         EEhfHnJvvsNn5DHYJN24wL5tOLQLy3sBYkI3BC7kC/lmEwc7SOCawPIjIj5h64X3gVfn
         K8pPL12Ym6YfGlZV8x5vtUI1mbzYm4YTr/Z+ax1hxI6AJAz4kNJG1ewcHj16uuHJm34O
         ykZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=yZ72/ZRga4sP6om7onH6tGWgYIV/O0JzzYeCcRM9u0I=;
        b=Y+SCkdo5DuiSVGBIhOEuTcp3IiyvSGBxfoq8ZVZkbyRJ0WgaqanCfQVFigbpvdXucx
         hAcuyrYE7UyINANZ9VDsybgxB0XxPuX4nkCIUsuVHLXqzU3E225Aa6EyaG511F6E3+HZ
         u6F8ny+wkFMoeWNNvz5uXArR8ypmYxWF8J+ZDHhznaTWXjkJy5WYbUCE7oosnu+T1FZT
         pek7mBczC6F66d3etgUOge06mpLtVgOKz+3HfQ3k1Xp7uUwOMSIqrqh+n0y3ZQipBSOD
         cZOzGiHvofT/p93gJOtSZYyqa7fr9LcdwWyRRhAxBmfN6GJArD5fgK9CSI268uDYU2iU
         wuIA==
X-Gm-Message-State: AOAM5303MWvF3zT4DECDNFXweD71irSHnEkYRAzN5tbIsfbPPDrrQE6Q
        mB0b58xvbPVE//6dtJZ3Im0W8F0sBnfuf799Qjv4tTWe79RoDw==
X-Google-Smtp-Source: ABdhPJwo26SHbW/8nZecVMhhpE7BToH6f1RB2LjGmZMWyUAHYQSIBvMpqj3GPiJ+ePo9ZFkhumash8KJPBTVasFmzJ4=
X-Received: by 2002:a05:6808:d8:: with SMTP id t24mr11498884oic.10.1590492190734;
 Tue, 26 May 2020 04:23:10 -0700 (PDT)
MIME-Version: 1.0
From:   Cong Zhang <congzhangzh@gmail.com>
Date:   Tue, 26 May 2020 19:22:59 +0800
Message-ID: <CAOXDmPqHBGQ=k-K0PjEkp9fAJyu3hoxgQAV10OMXBELc-nkfpA@mail.gmail.com>
Subject: espintcp will crash kernel randomly
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Devs,

espintcp crash kernel random.

The last level of callstack are something like:

invalid opcode: 0000 SMP NOPTI
IRQ
tcp_gso_segment
...

if I use ethertool to disable gso tso gro, it will never crash again, why?

ethtool -K ens11 gso off gro off tso off

Tks,
Cong
