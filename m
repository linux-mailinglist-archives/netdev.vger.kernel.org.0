Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE68432EC6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234339AbhJSHDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhJSHDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:03:37 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0F28C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 00:01:25 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id t184so15950334pfd.0
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 00:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=ZeMwK2oadO0ZU4hiLT1BljgCDxoyNvDtTWdD97YkGh+znqlVZ74sOuwM2lXJbdK3fP
         wACRbbDkE168gt8Dilv3IvsEdwF96Szk2xESIKDFKHKgsXYPQA1Iy4UM//9l52X0OzIb
         iheTfeYROKGcmP/orDDOmgtqFMWrThWzcCUXo8+EHfpQSrM+eiwgNzm3O9GfPzDJTQTl
         l+0RSJlIYbXsd5omvgEYLRGIPEP+pgsu/97a0u9egjFv6SBpYrJQAzDp05ghkRueDoF2
         LsKRqEH++y05MLC58rVLU+R/cG46Kz3aIoAtJ76x7SkDuF4xEssG6onq3QdmrZnweW7A
         PIMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=dN+NUw+bV/aRADaa3GuSALAyZ6016+CDjQLgIEP63Tl5uwKHwZDwkgKNYVLfVg7e1q
         v8CA4IoG3OaNEOYqz+PWw4Ebpu1ZqC+ZUaLeWwltT7FecizMcvIchkgUZL3BtSjkQpUL
         Zo5CO85J0l+IMcaRVsxVLYEfzudmR0xKl7S7ftzvrPklNq2fPa4O/Nc/XNiX6Kc9q1fq
         gwf0vmgYLoF8ZrQn49yokq0cuO+Ytfh2nQ9V6kfjfjWqfnboVKqOoJTno3rUOZ881UW1
         92VTaugNM6fDlwmEmdN+ZPZWY04XXAL0jDtPP9hb/IR9oiMXeNbCO4M9piVbnScJGxA6
         CQ6Q==
X-Gm-Message-State: AOAM530lGteZiyVUDwl1K/7re3bAu3fYfrCaYpTUNQ05Ke+5c4ogY0PP
        9TQW5ArW64s8fsSYkEBjLykHEe6GNMigWfrhPlI=
X-Google-Smtp-Source: ABdhPJx39u2eAi9t8/R5K7AJwmP9rh3jDvYLkJYstP/mZ550YlYF6lXTTpNDWr8exQFvaiqCpqizCqdGUSAaTfohU9g=
X-Received: by 2002:aa7:8f12:0:b0:44c:833f:9dad with SMTP id
 x18-20020aa78f12000000b0044c833f9dadmr33390954pfr.35.1634626881495; Tue, 19
 Oct 2021 00:01:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a10:e2cb:0:0:0:0 with HTTP; Tue, 19 Oct 2021 00:01:21
 -0700 (PDT)
Reply-To: michellebrow93@gmail.com
From:   Michelle Brown <ambrosegnona@gmail.com>
Date:   Tue, 19 Oct 2021 00:01:21 -0700
Message-ID: <CAApYH-qxmvYfwacfhuin=3pens3_V+z7grMfP651G=xWruiCEw@mail.gmail.com>
Subject: Hi, I have something to discuss with you, please reply me
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


