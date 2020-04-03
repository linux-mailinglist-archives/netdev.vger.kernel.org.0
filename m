Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4500319D7D5
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 15:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390904AbgDCNlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 09:41:51 -0400
Received: from mail-qv1-f68.google.com ([209.85.219.68]:42153 "EHLO
        mail-qv1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390808AbgDCNlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 09:41:50 -0400
Received: by mail-qv1-f68.google.com with SMTP id ca9so3541131qvb.9;
        Fri, 03 Apr 2020 06:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QTPwH9DQl2UBuEZwi2ElzFxHr6i9n+qwPg8+9YYUPWU=;
        b=BlmAatI+0g6pDfys0U/vI1PhD3GeHN/sSx1hu7RAVbVo0+y/29CoJxdl7uHv0LnBmx
         7mnjkgS4saBRKLO5wcj00f3fzQY/7TV6CfLIaGb/MGZbcaCE9DMOIXv0XptC/WbJCKqL
         aoX7O/xYWolJ6Jy0CADhtVfq1vMiMkAnF1LgP/cR/D5tFEyYof/V0gRFwELyzGZb3J4i
         8vxN11sMQMLPYAZAdin7ogRLDcdXvvXcjivzwf0bK8ALpMW8AYtpIPRPRqBhqkw3RHe8
         UYGLTFtPa6IeiOACSFqCi0NQeTgu8Cbc0McCGw5cTRtnRwb5Fl8Crnddnb0BPNk1RC2s
         0DRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=QTPwH9DQl2UBuEZwi2ElzFxHr6i9n+qwPg8+9YYUPWU=;
        b=kG4pZWa9PBoPMFTWHxFVg/w3EvXv3lvcKToL/hML59jzwgso+UZTUi8ojhXxaFUa0m
         Re27NEBYY53pluL6oNBbYjL3zUo4E+IufgaIOoCvWV2xdTksdi0h6peOQ7bEYOFk6dCe
         Aje7X6/YSsDAT52+kDoy1ykqePbjXcj5aRHfbEdd0/Uv7dB+jczZraKMs1HZkF8XzFC+
         QM8lWtbrmAZaKW/FLkouV2/BqjwQX6CgkRe/zwF/ms0DOToXCZsSsPHnKrEM4HA3olSb
         m9rj3K7FvDFbD9CKLlCJVfY1ZIEkI28QAdPMHXTRYt9VcltArUprZRTM3zBAZ2asvL8h
         G7JQ==
X-Gm-Message-State: AGi0PuYt8cSAQkxKFxS51SsGIc3Vt2UVDyawFQ6mMELwJ9kdA4kZ+Dss
        Yzd+XPqxKuCCKkNdZvMdCvg=
X-Google-Smtp-Source: APiQypKqMe+fEACiQ2mDqiwu9r5KRYbe5bmwdIo3fsooh/0bKuMRej6+dn8+D5fjBcmLUBJY+dhcKw==
X-Received: by 2002:ad4:5112:: with SMTP id g18mr8391477qvp.54.1585921309322;
        Fri, 03 Apr 2020 06:41:49 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::842b])
        by smtp.gmail.com with ESMTPSA id 207sm6381651qkf.69.2020.04.03.06.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 06:41:48 -0700 (PDT)
Date:   Fri, 3 Apr 2020 09:41:47 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        khlebnikov@yandex-team.ru, cgroups@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH v3 net] inet_diag: add cgroup id attribute
Message-ID: <20200403134147.GX162390@mtj.duckdns.org>
References: <20200403095627.GA85072@yandex-team.ru>
 <20200403133817.GW162390@mtj.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403133817.GW162390@mtj.duckdns.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 03, 2020 at 09:38:17AM -0400, Tejun Heo wrote:
> On Fri, Apr 03, 2020 at 12:56:27PM +0300, Dmitry Yakunin wrote:
> > This patch adds cgroup v2 ID to common inet diag message attributes.
> > Cgroup v2 ID is kernfs ID (ino or ino+gen). This attribute allows filter
> > inet diag output by cgroup ID obtained by name_to_handle_at() syscall.
> > When net_cls or net_prio cgroup is activated this ID is equal to 1 (root
> > cgroup ID) for newly created sockets.
> > 
> > Some notes about this ID:
> > 
> > 1) gets initialized in socket() syscall
> > 2) incoming socket gets ID from listening socket
> >    (not during accept() syscall)
> 
> How would this work with things like inetd? Would it make sense to associate the
> socket on the first actual send/recv?

Oh, it's not a problem with your patch as you're just following the associated
ptr, so we can have that discussion separately. Looks good to me from cgroup
side. Please feel free to add my acked-by.

Thanks.

-- 
tejun
