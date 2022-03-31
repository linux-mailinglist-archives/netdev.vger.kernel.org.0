Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCB74EDE9B
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239804AbiCaQV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236949AbiCaQV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:21:28 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4866F5575B
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:19:41 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id i4so503410wrb.5
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 09:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=7p6hqD+u5H3FTZ/1NFMMfJSrultHsKQZRe7c2mrNd2I=;
        b=e/XRh479sb3Psbz0wdu2RmfvXxEcuGe7fVDrLky3lqIznblds2mJpTrgc+lJEiXHJu
         Md7Dn6kcZNI/taRV0L4BfGCSl+gL2Vvnyi28K7JFhi92G2nRxiKwrnR0sKIyR37L05kR
         R04KWQqKY1dfxKcvUZghQp8pME6yB9114lbzwnWXqLa91Qsyj6ZIaokGAq6NV7402oct
         aOaSyXaA2mSy5xmhFfNeanQdY7QUd3glNcjRQ+MySWMTz5NDurmkl2+hIFIz5bEc40UT
         kDvSW+tn9GVvNFR7dim6xNLHlaCLTF4VCc7QtRcns5SXBkGyXvSdCHV8/eU9slHJlhkn
         LoJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:from:to:subject
         :content-transfer-encoding;
        bh=7p6hqD+u5H3FTZ/1NFMMfJSrultHsKQZRe7c2mrNd2I=;
        b=dExoQzRUbEWB484BYwxcOqFwAzgWgz3J0Y+4QCOEHQqWtoWQRwCqnPYKcrLJyNZIr+
         S7C8PeN23TqZem14FoD7Y6aRfZAiAXWoklbAavcEGvDjexPiDCaVp3NNF2aLcWrud+A4
         N7UYER9JU9Blh2sbTRRup8n5jzbCvI4GhwQQYmSc9TuFo5Vh+xC2qu7MhKrhe2peEFcu
         UGYTPF2gAghURlEMaHIncu4SX3ZWOcE8HPTXMu5NPj7MFd/sAeqqi9SowkBs0lyOYEc2
         pMxIdf4MPnMRwcghbfZzAteHxPuhUtHOU8R+PsLbAjgHBMk8EB/OFNIOjtdSzcY1Y7jM
         ziZg==
X-Gm-Message-State: AOAM530ituaz5UhrcVdaFOlZowwAHTrGkPABMx27OZDCW0Oo56q+qxOs
        WJBZkdoEE4x5bUVbHOwk8wDxf8rQwnqVZw==
X-Google-Smtp-Source: ABdhPJxCiF0mTnspMKSUX8+USD7lSCGQjMbYrXXWdKyAv50CJLtw2Rvx1APd8qEpaN5P4R98Eu+tPQ==
X-Received: by 2002:a5d:4ec7:0:b0:203:de83:6f44 with SMTP id s7-20020a5d4ec7000000b00203de836f44mr4713108wrv.56.1648743579670;
        Thu, 31 Mar 2022 09:19:39 -0700 (PDT)
Received: from DESKTOP-R5VBAL5 ([39.53.224.185])
        by smtp.gmail.com with ESMTPSA id p16-20020a5d6390000000b00203ffebddf3sm27232459wru.99.2022.03.31.09.19.38
        for <netdev@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Thu, 31 Mar 2022 09:19:39 -0700 (PDT)
Message-ID: <6245d49b.1c69fb81.8b2bb.ba83@mx.google.com>
Date:   Thu, 31 Mar 2022 09:19:39 -0700 (PDT)
X-Google-Original-Date: 31 Mar 2022 12:19:38 -0400
MIME-Version: 1.0
From:   ulyssesdreamlandestimation@gmail.com
To:     netdev@vger.kernel.org
Subject: Estimating Services
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0D=0A=0D=0AWe provide estimation & quantities takeoff service=
s. We are providing 98-100 accuracy in our estimates and take-off=
s. Please tell us if you need any estimating services regarding y=
our projects.=0D=0A=0D=0ASend over the plans and mention the exac=
t scope of work and shortly we will get back with a proposal on w=
hich our charges and turnaround time will be mentioned=0D=0A=0D=0A=
You may ask for sample estimates and take-offs. Thanks.=0D=0A=0D=0A=
Kind Regards=0D=0AUlysses Kraft=0D=0ADreamland Estimation, LLC

