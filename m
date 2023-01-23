Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3267767878F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 21:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231634AbjAWUU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 15:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231501AbjAWUUz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 15:20:55 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587B2367F6
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:20:54 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id p188so16380884yba.5
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 12:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ScZWRv6o3krn9eQJlYFo05S7tO/p0EShtqa9D+dIhjQ=;
        b=DaFK0g/PJSSkUgzyPLaKJrooT/j8KJOjxt4xSXhW1cgCl4ft6feuv8oGBjauPJ1dRP
         HAHNV0Wo7u4PoQSKCIr068regBp3nmIx8qjs9fpAwFTvCPeZn3wG+lQT0O1smPgaj5SU
         QQyGj0e8B56evjYnZpx5J4ecWQXxmKsjiepRsVkjQD6ObTzDHhQYRsNb35tGmJs4NUGZ
         /7HTgJB+nBh0risXRVzIJPkhHZ5nbxuzDG2ieJVh1nuyJLnYpdkpItt6aYBGr5ZyUXtW
         yIG9bA0iMbFnZKNOXn0VtTHSaI2LUE3NPtWyHi95gPqzmjXsTrPO3AZpqC5cfmf1oGus
         rs3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ScZWRv6o3krn9eQJlYFo05S7tO/p0EShtqa9D+dIhjQ=;
        b=Y7+ujAG7ZuBN4ZjU6Vcr0Sm1kASvybhh2s7cp1YXRbF/qpEu5evP2o6+GPHYHAGYBl
         AK+3CCgzGt8+Llk3Jo5Xz2JSCLFAQLDxNPB0CbJQiE+K1k+TXiyDzj/hgD/UxVSohGDw
         uAejF+I4GvbJzdlT8jOd67DHC7I2dg27f2KxJOFyx42zcoim6/jpDFxnhXx0aBLiDFC2
         vxlOAN6aGsqUPyW6hBWUwTf1CrfnBQH60eg+FGElNFy7UgwoTZMLYEN+1oDmzkLu/3PN
         LfdE7fodEPXdnQ38K5zYeYed08TkxCADtNnFOV6H9fh+qORMJGLx+KKz7h6fRTycQJjj
         3A1Q==
X-Gm-Message-State: AO0yUKXewTSTv057/QlKjbO7FRm+DsEBLrdDfxS5IYQ201kLZwHDfy+L
        Vw203zVVXnLGhthE3gLoPkUtHcJDduZXg8H08Oc=
X-Google-Smtp-Source: AK7set8qyrsqeSbyHEbYdHGfvED5NvtHi/H4S1naLRYR9DAmrgAdn16piaNAXqwNGJDsazKPtL/+LJtyhnDWii7xd4g=
X-Received: by 2002:a25:346:0:b0:80b:5c18:a17 with SMTP id 67-20020a250346000000b0080b5c180a17mr39337ybd.394.1674505253301;
 Mon, 23 Jan 2023 12:20:53 -0800 (PST)
MIME-Version: 1.0
Sender: lolorachida@gmail.com
Received: by 2002:a05:7010:4da2:b0:31c:ed82:deec with HTTP; Mon, 23 Jan 2023
 12:20:50 -0800 (PST)
From:   DB HM <mimiabdulhassan39@gmail.com>
Date:   Mon, 23 Jan 2023 20:20:50 +0000
X-Google-Sender-Auth: ZHuvgy9q9lzy4D1_CIIsNTIfIY8
Message-ID: <CAPDHN6r7W6=0NytKNU7NYMDz1xMs2XhJ12fFTZQ9rgg2VCCW0w@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If you are interested to use the sum US17.3Million to help the
orphans around the world and invest it in your country, kindly get
back to me for more information On how you can contact the BANK and
tell them to deliver the consignment box to your care on behalf of me,
Warm
Regards,
Mrs Mimi Hassan Abdul Mohammad
