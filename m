Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE4FAE0D60
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732071AbfJVUjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:39:31 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36282 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731398AbfJVUjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:39:31 -0400
Received: by mail-lf1-f68.google.com with SMTP id u16so14198972lfq.3
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 13:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=38DGl3nPqfFsklGBVs5Uo+Om9XtfHJi1J5IGmBXqaaQ=;
        b=kCoZ78reb5yHDK3mP3U1hVx+acMo+Gm2oCNk0so70BBE5Zu9yFYMTmD1meyofr99B6
         7pOTJR0HG6ZmadunEQX6/eqUbkq+GJ6vzTIaElPCLKquVeiZuOzoqar9e0ns54+LLRzf
         o+EA6No8rCAuSgQqofIak/MXa/hHUu1ZyWytoX8i1tK3rAwJPQ1AACZjQUSuZAoBKDBz
         Fn108Ux5XS/ZBm9aekzkjgmK3JKafNy3v1l/LtT6uYAufRmrFB1bS766Fhu/Tx+tyJTt
         E8dzDXdk29zCjGsWBwYCdNQWzRimYS16nMNz77/CaXDrBMRbnFOcN9k7stEXzRFcgJkf
         BzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=38DGl3nPqfFsklGBVs5Uo+Om9XtfHJi1J5IGmBXqaaQ=;
        b=oZNGqRxjVVNakrV5KQBEk9QeFhDZEYyDLV5XHFD/lIT6R9xBs20kmGO5/tebyxxaVp
         O9WGKTth1Bk+LnCAyW6ZkOYDMfsLLSDlZO4ksqwnbVd/54saXwScHCEZ/dFqN5n6+cAI
         0HC6wOIagTnX2BlygCUZfJWKNPhdFNi6/LYixEaW/jrdt09a/psGGINiBk/8nILO6GYS
         cI3sikHVY7zhhTE1Xv903rNUygFm1EXVkwDbk8hPPexOhB8dC2QzdVNf+TZRMINQCrvX
         mvNvtBcQfT3+uapjgebqmcxbXvLdgPAvGCzwaS6ySVcG2O6LnUX41rk/9gyGlatpk4kA
         IDDw==
X-Gm-Message-State: APjAAAV2U8FJYhalwPFadh89xrpSyz0XLH3AMp0A7b1QBATHam4FyfXM
        nQItvcZoh4s27ePnAYfdegcQs84JsRI=
X-Google-Smtp-Source: APXvYqxHmFSxjbHN/b1h1ODrWfLW5wj2j/YE7RQvsafee8tng2tNAH6DWqton8e3D6rw5vjSX/CcJA==
X-Received: by 2002:a19:c214:: with SMTP id l20mr19391609lfc.123.1571776769018;
        Tue, 22 Oct 2019 13:39:29 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 4sm9093313ljv.87.2019.10.22.13.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2019 13:39:28 -0700 (PDT)
Date:   Tue, 22 Oct 2019 13:39:20 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yi Wang <wang.yi59@zte.com.cn>
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xue.zhihong@zte.com.cn, up2wing@gmail.com, wang.liang82@zte.com.cn
Subject: Re: [RESEND][PATCH net-next] net: sched: taprio: fix
 -Wmissing-prototypes warnings
Message-ID: <20191022133920.087f1779@cakuba.netronome.com>
In-Reply-To: <1571702262-25929-1-git-send-email-wang.yi59@zte.com.cn>
References: <1571702262-25929-1-git-send-email-wang.yi59@zte.com.cn>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 07:57:42 +0800, Yi Wang wrote:
> We get one warnings when build kernel W=3D1:
> net/sched/sch_taprio.c:1155:6: warning: no previous prototype for =E2=80=
=98taprio_offload_config_changed=E2=80=99 [-Wmissing-prototypes]
>=20
> Make the function static to fix this.
>=20
> Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
> Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Thank you!

I've added Fixes tag and applied this to the net tree, since the warning
is already present there.
