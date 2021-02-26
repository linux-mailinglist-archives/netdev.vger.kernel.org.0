Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2224B3263D2
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 15:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbhBZOLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 09:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbhBZOKv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 09:10:51 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3B2C061574;
        Fri, 26 Feb 2021 06:09:57 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id o11so1805552iob.1;
        Fri, 26 Feb 2021 06:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=QA/d0cFunzbxzCuiklavIRwd25SEC2LCzhPw4fegxCo=;
        b=XqMcdEoTrxRRGDlG9nwcvIXz45i1/9KiirgMGaAJUxUQjlUDy33iaM+Uk2JfEG4e8X
         a6d0I5LGe8ZNcv2oyaj0JfPXmFASYmrU10dDLdEEH8JECPxmL9LK0cNw/lZplANQY0MD
         Nbn6X6IgYBAHddDY1aE216Cfl2onJpPaKi/VaVel2Z/wKpWauG90x0oQFIfxdvEKM3L2
         +38+LVg0j3iydZ2Uv6oQHB0nSWkbJ67GihJPqEnLv/KOuXJcxkFTUkD007u0roQ8BCVR
         TykLw4RBW0rwD74AhmjoPN3ELoi1GD9rrb/f0L3T8DvDu+oRVZeNpCrpmrRmhi9qQnCL
         SsIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=QA/d0cFunzbxzCuiklavIRwd25SEC2LCzhPw4fegxCo=;
        b=V4Aw+KIGFT7RAnkp39Eoc3e1JCDFij/vC1sOZ+ZcXqgSZTcyOaWJkTYMIH1WP3W58a
         M4PyGxedjAPGm+eVuNVVMaYQIuEFOYYMZKJyNN8bP7FaRguzqwU0OpRBZ5M1ZYqWxELI
         Kzo0ZYu8+HUuM+vNdwqPEnNnkB/+365Ib3Ka2ae0nRWB0hT2Bumm13+oqmIdux4dDqgT
         SICxBCv401qV+NW8/E6psu2zNS8Nq8v86NieT+AjN8oXtbKWN7dH8JcqwjcIGbkjKxWM
         O11C80gizSd+9vcVae53V7lDljQ2mUwhdePrC+huIqlVm7y6r7cBUJsr1gtQ3bKRS7Rt
         JN6A==
X-Gm-Message-State: AOAM532+xsUssrjaZ37cu8gytIhlqn7chG5TTT66MdOheTycyIOyk6PN
        Vlwb0h6OyWq6EpyplUpdKAQpzq0qxPJsKWtV
X-Google-Smtp-Source: ABdhPJzUtiamVNwT6wcNQlzQhqI8qB6XodhQaVnErvchcxDLIhot2fWopEldwVaGoneCN3Li7UelpA==
X-Received: by 2002:a5d:8b8b:: with SMTP id p11mr2915771iol.45.1614348596698;
        Fri, 26 Feb 2021 06:09:56 -0800 (PST)
Received: from llvm-development.us-central1-a.c.llvm-285123.internal (191.6.226.35.bc.googleusercontent.com. [35.226.6.191])
        by smtp.gmail.com with ESMTPSA id r12sm4657881ile.59.2021.02.26.06.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Feb 2021 06:09:56 -0800 (PST)
Date:   Fri, 26 Feb 2021 14:09:54 +0000
From:   Vinicius Tinti <viniciustinti@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsa@cumulusnetworks.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Cc:     Vinicius Tinti <viniciustinti@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Similar functions in net/core/dev.c
Message-ID: <20210226140954.GA752212@llvm-development.us-central1-a.c.llvm-285123.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

All these functions in net/core/dev.c are very similar.

__netdev_walk_all_upper_dev
netdev_walk_all_upper_dev_rcu
netdev_walk_all_lower_dev
__netdev_walk_all_lower_dev
netdev_walk_all_lower_dev_rcu

Can they be merged in one function? Are they a hot path?

Regards,
Vinicius
