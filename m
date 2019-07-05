Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8972B60799
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 16:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfGEOPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 10:15:15 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:33056 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfGEOPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 10:15:14 -0400
Received: by mail-io1-f45.google.com with SMTP id z3so4479335iog.0
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 07:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Rnem+XHvujn5Z9R0/zYPTv9mWreT6X8SEUPYmA/4/kc=;
        b=bPXKVPy+zFXWKerVo2tlKC5RMeCux7ng3O4xBzNdrsrwCNtfxQ1NjJcjcrdz05lBz3
         Juho+CEgQ63XT2wbNKIPQezeCujC9Rv3vkasdf1acUWjG8zNfXTK+9DBAmWc/oNmNqms
         LxgRfdGFllJFDBPNd4SNbCG/EnLsI5oqet34QM2k6OP2CWR1b/DKVCjEwv7ZTx36h84d
         niJrfxgQtKUhTT2dnQNykDB2c5dOCACJ4wqEe59aACUBaE+Zv57CoFHD85/FthDI2ufY
         bIXRGW6WE90HyOSHMVMqPqFZumwqfWD/fOdKDki0uy1aErmaWEaO6Xl3MrcYxFwFxiEw
         XOYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Rnem+XHvujn5Z9R0/zYPTv9mWreT6X8SEUPYmA/4/kc=;
        b=hV3P4fdkCUvuI9R4TQ1hklJYyONyz6edc9Ty9jRapSy4ZHamg1NDZMUixreMhNYSqU
         7AOijVi11D1ScAfP9H0H/Mx/2wDyd0lAtoRcLKbxAcFc+Aw3wuCu0N7VV3qrAMDBSzc6
         ZQAyN+uyqVdxvt9AAbJ4a2ChvI+OGzthsk3Ng1W8r7n38zJjUOnLIDlfk4c8mgDFvw9c
         1Si6hTzMwNB02o/yxv2TfkqVz2ZR0koZX5xz+2sqhGlelc1DJGIxD4U6E1h+TLA1HGCE
         X2MvisIn+rEXqhvtpM/lCusvDWxhebi7VcaE6Avlu330uvCdY3yQBNE8HFe4vdj2q9Yd
         4LFA==
X-Gm-Message-State: APjAAAXQqgw7nn+dtPst7V3zhT/niGz31foZH1ufe1UN7m0UdI6BFwvB
        T4p8NOSJAlTnjrE+t19RfjAK/wwMdxi/HSLgKJwrd/Pt
X-Google-Smtp-Source: APXvYqxLrMl1r0clC3YKNkrj6mdMZJ/V+eQgeZAnLEuzDh8evXEbJ6jfsjWm52Z2zAfju3W+MXC3yD/mjYnnWCmjyC4=
X-Received: by 2002:a5d:9618:: with SMTP id w24mr4371241iol.279.1562336113779;
 Fri, 05 Jul 2019 07:15:13 -0700 (PDT)
MIME-Version: 1.0
From:   Loganaden Velvindron <loganaden@gmail.com>
Date:   Fri, 5 Jul 2019 18:15:00 +0400
Message-ID: <CAOp4FwSB_FRhpf1H0CdkvfgeYKc53E56yMkQViW4_w_9dY0CVg@mail.gmail.com>
Subject: Request for backport of 96125bf9985a75db00496dd2bc9249b777d2b19b
To:     netdev <netdev@vger.kernel.org>
Cc:     Dave Taht <dave.taht@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks,

I read the guidelines for LTS/stable.
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html


Although this is not a bugfix, I am humbly submitting a request so
that commit id
-- 96125bf9985a75db00496dd2bc9249b777d2b19b Allow 0.0.0.0/8 as a valid
address range --  is backported to all LTS kernels.

My motivation for such a request is that we need this patch to be as
widely deployed as possible and as early as possible for interop and
hopefully move into better utilization of ipv4 addresses space. Hence
my request for it be added to -stable.

Kind regards,
//Logan
