Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708894D6A1B
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 00:26:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiCKWn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 17:43:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCKWn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 17:43:26 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D3418642B
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 14:18:36 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id bu29so17555473lfb.0
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 14:18:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Tt33SgTbY63YfUaFxtS71HjpeEKKi+UnOCvCWq5aDYg=;
        b=DpeY0rn0nXCOjZBF6d8jt/BGI5JI3z1zm+e89G4W8IigJpK4PFj+eOFXDmoENQCQ7/
         myv1bput7wQXpq5c00JqgWFqToS5YIOQLfZmikYH9xQ1wS2m1I1E/7yZDR90ZxiQgxzn
         uKEzXSuBSHpkdJiYMNCD7siTBzcT7hOwvjPXipCkKCJBh9FyrjuoAurOQMRPrhPa1CWm
         c/9bDNqoBSLYflXoKjUPPEO9mjRGxY9TC1AZvJNMnLpL/zTcaDEgek9Es11IZw01LtJU
         6BBhba25kYMXfnbJOlLnYrGL/U7Qa8aFDgf2zMM1EAGeknatQGe3q2HjvrZJJUGR1WZk
         pr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=Tt33SgTbY63YfUaFxtS71HjpeEKKi+UnOCvCWq5aDYg=;
        b=FtrvlTteh68rEks6d+IWc15QFQCzU8+iawZk8RLHW56X1+xeXUxtCn2KWpNbTyKQoc
         S6AntSy+JS350GQ1dWgEXyHluHXLGab4/RX64fRtx+WTyKb9kvy2nE0AcjxkNx2nF2AK
         wnVxIc0RP2IFt/vHQZulvl1zBvQCL1k95pmzBzl/fEEVga7Hur3m23Dujg/MepDZIo9s
         QdjayJeUCsTAG+dekihZXMxCfi8cTpI7o5VdEt1wJQ11MjrsOt/rcQSFbc9LOjx5Am28
         DLclJxLJAPDHKOH4zEwlYd77gK+cAjLFhsBksw+JpaFqq0brVBD9fQjACfbYrAgsQT8n
         Ob9w==
X-Gm-Message-State: AOAM533pqCRJOSreoAsdNLhydJ98Ca+G+1RIoYsvwtYG5iBrYUerih9y
        JdVHrTDI0LQtOQiJGYaZ7i8hxIZ7BwADaplg7pcXTXGJ7IVhLg==
X-Google-Smtp-Source: ABdhPJyyE2Dj25CvvJhz22WHVRIEwpBPGtPbOy1n4sfqoVYX7McenphjQAZPyrJdalnVqwbgarS+pVlL+Ek06fgq3UE=
X-Received: by 2002:a17:906:3514:b0:6cf:ea52:50 with SMTP id
 r20-20020a170906351400b006cfea520050mr10428589eja.134.1647035228024; Fri, 11
 Mar 2022 13:47:08 -0800 (PST)
MIME-Version: 1.0
Sender: daviselena147@gmail.com
Received: by 2002:a54:33d0:0:0:0:0:0 with HTTP; Fri, 11 Mar 2022 13:47:06
 -0800 (PST)
From:   davis elena <elenadavis818@gmail.com>
Date:   Fri, 11 Mar 2022 15:47:06 -0600
X-Google-Sender-Auth: 5L6SdazToS3uozCa6oCf0VG_7I4
Message-ID: <CAPmcWy+cd9X3iP61Ghd7e8H8g1OLYWdvxTmsQxQO6RYk5-TM7g@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=20
Ciao, mi chiamo Elena Davis Rispondi al mio messaggio, ho un pacchetto
interessante per te. Cos=C3=AC possiamo saperne di pi=C3=B9 l'uno sull'altr=
o,

Auguri
