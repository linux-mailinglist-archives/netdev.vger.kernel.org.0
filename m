Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B5E1FD098
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 17:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgFQPLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 11:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbgFQPLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 11:11:07 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125A9C06174E;
        Wed, 17 Jun 2020 08:11:07 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id y11so3290456ljm.9;
        Wed, 17 Jun 2020 08:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=XKplk/49FzRhoeuSXRDg36gjhZd5p7mlQ+79XImMqL91rHx8Q15TlaHyIZiIodaZMS
         6DKcp9/PqEhQ6VS0meG2WKLCFIjOftlRl+nVL00A6R7VQfZie6Mzt8qdp5L+on5QHoij
         GIN4CYk7hNcrAbaKtnrAzJS9bWKIOZcVdsi9dC83VNLnSqntCwn/6m/Vfkan6LX99CEN
         cqiI7lcolQ3+I7xfDM7wA+bQeg3PCWz6VHb/DVmmn8J2Nc6CGp+I3UaFKLG/Qp7CiWdS
         NdU6lfHqYm+ix24f7ZYbbQ/p9Y643pMJoioZM25+4oULE3kjezwl2bnnO6rdbQSDS8eq
         Y+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=oA482Tb/bm9BpcLEMVTA93M3DH/UILM+eZJGFQfuxpCkopjtLUjas0SGmFAtqiA8zm
         rLEE30YTAFyUpf53uf9Pvz+W3jGjKaIuotmetDezRi6pCRXpjkaY+jYEtMjR7VVCXZ/7
         l22WVnwn6fIZgKcH3wybX9HRXQQcf21ucCUXOM/ZT2UjefGlq00XgaAC+SyaDHmaYXE4
         g9GpuQmJP6k5i15aS65+tb3OfCpDwMs2YDkthwBtCDWLU7HFAFVvaeogP6gRvHZtLvjp
         zhRWzadXPptbS075I/W0DjQmjXVCa8VcM8uldGjdHAe1Qv2W7f0QUYzDAcbmdS5WZ4mw
         Oz5w==
X-Gm-Message-State: AOAM5308+lJ5u8bO6g3GJaa7TMDh7Ls03yw0r491wPgeUPN8nae/ZURT
        4AqHTH1/R5jyBk47w7HolxbIYuw5JM/cQ5eCbvQ7gg==
X-Google-Smtp-Source: ABdhPJzBXZwVpnxJM00d1d01W/5k4VOHSmWwVKM3BMhaVNp5DdUU6KA32lFDhRrtiVhpai3zSVc3J6TA1eTfYC2ykNY=
X-Received: by 2002:a2e:2f07:: with SMTP id v7mr4071982ljv.51.1592406665104;
 Wed, 17 Jun 2020 08:11:05 -0700 (PDT)
MIME-Version: 1.0
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Jun 2020 08:10:53 -0700
Message-ID: <CAADnVQLm44icJp60R6xVimy3m1sK53+8m4dOTy-_-AWtgwRawA@mail.gmail.com>
Subject: bpf-next is OPEN
To:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


