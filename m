Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A236516E51
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 12:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350506AbiEBKra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 06:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240862AbiEBKrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 06:47:24 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F8413DF5
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 03:43:55 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id l18so26960238ejc.7
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 03:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=QRCVia859CvI1FcacIK/vRlTfJd+SbxpysHOvI3snNU=;
        b=JzyaFcUZGLafCnGVkuITvq7Fny5tLwae6pd7PJffkyCgHTtY+M4tBVeFt1RH7HrN/q
         YvpV4SfU2F7fkUUzn72oknHijExLJ0hGAz/uUFYrgsE2u7MZiA91RuxeAuVLOzUsPekS
         o6DEKdJOfcN7WryS5GLWhKCRfLsp5FnX6JbTzfJydbQWyFadZgmaxcBEJ9t5Lc1Gr52M
         I2FVcrB+kq+7CeH7eeI279x1Yb+VXTeglTt3+h1/iWS6ycN9HHJtdKd5j4ShQNcPBeOZ
         C42ciV9PCO95404/tLvFOuzFAHY7XhoXz7uKeELjbHpMtkHE2CGSqyJwDmCk85MpB+e+
         UaEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=QRCVia859CvI1FcacIK/vRlTfJd+SbxpysHOvI3snNU=;
        b=gSL+ReKKr7iws+7BAG4x8xrUTh/WQcdoEPZM6OlFgtYzf+DSIKajWmkn1gr1ydpy1i
         Z8WFm9XRYFBqeIZC8CToMXXi14d90hySoViLOhMIyQTnjf0C5X+PDmJ9Q5kp2gzy4uIG
         J1gcBPRDsnXSMR8gJHrbj/xj1Ta8MwbQ1GQlfSTDKkwvnYHdGoFRB1A5Zk7Ob4BKeafr
         TLRVr6urqTrIy5kkl5uL/uBTh5SBR5dVRKYAjUmQVpdKRO3FY27dD8Oa14Mv12HWXPF2
         31YFgYfDLQAwoymfEGAnCQhKFPm2BhV5jSN2kRfAu1rA178JuHKybvE1XbmnsD67s7qE
         hgXw==
X-Gm-Message-State: AOAM530kxtjH2OTxL6kd4OCAlu4ToX15txTaBUrSzoMP69+iHF2tp0Vn
        YoJffAFbOdW4rmgD5x87fmwg0aDjjkMHpBnujNo=
X-Google-Smtp-Source: ABdhPJwX32mVDittCrr/FnxJT4YNU7ivtuvSeUWx/kN74Y415B67ohZgceWlW8yWqP+lt7tJWgK+D/aOdfTRcY/EuuA=
X-Received: by 2002:a17:907:1ca8:b0:6f3:6d36:b2e3 with SMTP id
 nb40-20020a1709071ca800b006f36d36b2e3mr10695736ejc.88.1651488234231; Mon, 02
 May 2022 03:43:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:3147:0:0:0:0:0 with HTTP; Mon, 2 May 2022 03:43:53 -0700 (PDT)
From:   Frank David <frankdavidloanfirm3@gmail.com>
Date:   Mon, 2 May 2022 03:43:53 -0700
Message-ID: <CACPaKznaCEkrv_3oE3PfM+MNNsDv6r2ppBCBNoBjmSC14EjK_w@mail.gmail.com>
Subject: =?UTF-8?B?0J7RhNC10YDRgtCwINC30LAg0LfQsNC10Lw=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

0JfQtNGA0LDQstC10LnRgtC1Lg0KDQrQotC+0LLQsCDQuNC80LAg0LfQsCDRhtC10Lsg0LTQsCDQ
uNC90YTQvtGA0LzQuNGA0LAg0YjQuNGA0L7QutCw0YLQsCDQvtCx0YnQtdGB0YLQstC10L3QvtGB
0YIsINGH0LUg0LMt0L0g0KTRgNCw0L3Qug0K0JTQtdC50LLQuNC0LCDRh9Cw0YHRgtC10L0g0LfQ
sNC10Lwg0L7RgiDQt9Cw0LXQvNC+0LTQsNGC0LXQuywg0L7RgtCy0L7RgNC4INC40LrQvtC90L7Q
vNC40YfQtdGB0LrQsCDQstGK0LfQvNC+0LbQvdC+0YHRgiDQt9CwDQrRgtC10LfQuCwg0LrQvtC4
0YLQviDRgdC1INC90YPQttC00LDRj9GCINC+0YIg0YTQuNC90LDQvdGB0L7QstCwINC/0L7QvNC+
0YkuINCd0LjQtSDQvtGC0L/Rg9GB0LrQsNC80LUg0LfQsNC10LzQuCDQvdCwDQrRhNC40LfQuNGH
0LXRgdC60Lgg0LvQuNGG0LAsINGE0LjRgNC80Lgg0Lgg0YTQuNGA0LzQuCDQv9GA0Lgg0Y/RgdC9
0Lgg0Lgg0YDQsNC30LHQuNGA0LDQtdC80Lgg0YPRgdC70L7QstC40Y8g0YEg0LvQuNGF0LLQsCDQ
vtGCDQrRgdCw0LzQviAzJS4g0YHQstGK0YDQttC10YLQtSDRgdC1INGBINC90LDRgSDQtNC90LXR
gSDRh9GA0LXQtyDQuNC80LXQudC7OiAoDQpmcmFua2RhdmlkbG9hbmZpcm0zQGdtYWlsLmNvbSks
INC30LAg0LTQsCDQvNC+0LbQtdC8INC00LAg0LLQuCDQv9GA0LXQtNC+0YHRgtCw0LLQuNC8INC9
0LDRiNC40YLQtQ0K0YPRgdC70L7QstC40Y8g0LfQsCDQt9Cw0LXQvC4NCg0K0JjQndCk0J7QoNCc
0JDQptCY0K8g0LrRitC8INC60YDQtdC00LjRgtC+0L/QvtC70YPRh9Cw0YLQtdC70Y8NCg0KMSkg
0JjQvNC1OiAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4g
Li4uLg0KDQoyKSDQlNGK0YDQttCw0LLQsDogLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLiAuDQoNCjMpINCQ0LTRgNC10YE6IC4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4gLg0KDQo0KSDQn9C+0Ls6IC4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLiAuLi4uLg0KDQo1KSDQodC10LzQtdC5
0L3QviDQv9C+0LvQvtC20LXQvdC40LU6IC4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4NCg0KNikg0J/RgNC+0YTQtdGB0LjRjzogLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLg0KDQo3KSDQotC10LvQtdGE0L7QvTogLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uDQoNCjgpINCa0LDQvdC00LjQ
tNCw0YLRgdGC0LLQsNC70Lgg0LvQuCDRgdGC0LUg0L/RgNC10LTQuCAuLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4NCg0KOSkg0JzQtdGB0LXRh9C10L0g0LTQvtGF0L7QtDogLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLg0KDQoxMCkg0J3QtdC+0LHRhdC+0LTQ
uNC80LAg0YHRg9C80LAg0L3QsCDQt9Cw0LXQvNCwOiAuLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLg0KDQoxMSkg0J/RgNC+0LTRitC70LbQuNGC0LXQu9C90L7RgdGCINC90LAg0LfQ
sNC10LzQsDogLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLg0K
DQoxMikg0KbQtdC7INC90LAg0LfQsNC10LzQsDogLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uDQoNCjEzKSDQoNC10LvQuNCz0LjRjzogLi4uLi4uLi4uLi4u
Li4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uLi4uIC4NCg0KDQrQl9CwINCy0YDRitC3
0LrQsDogKCBmcmFua2RhdmlkbG9hbmZpcm0zQGdtYWlsLmNvbSApIHdoYXRzYXBwOyArMjM0NzAz
MjkwOTcyOA0KDQoNCtCR0LvQsNCz0L7QtNCw0YDRjywNCtCTLdC9INCk0YDQsNC90Log0JTQtdC5
0LLQuNC0DQo=
