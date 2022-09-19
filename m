Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F41E5BCE13
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 16:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiISOJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 10:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiISOJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 10:09:43 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B870663FC
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 07:09:40 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 130so42634452ybw.8
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 07:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=0VQuOBOAInh/oCFmAgnHFTRx83AeymR8zc8R+S3NTFU=;
        b=Rz/445BWfA4PJkfKPU4WKmiiYtEb7/PZiZ6CCMlszgG80zuaiqfxRmoT6rkQ3hQiZL
         A8y4K8rtKaXUZAocgZKd4GDWYKDLV0EXI9YYKBjB84AOi0jy1p0Vo+ojCL9BI+qWSXv2
         E+lBVeV58n4eNHka3gEXYfn+A6Rnhtsi9XRPQq5Bhi/U8bpd/OUccH7K50qmo0KGXRml
         MkpIpChgPGyIHhYqq2R0j7EM4zKwYe4JbKklzr9d/qsckbd1VKfCSpwtN03XGtW8vSLd
         BGQWWkEXTuf2zUcvAQWxP1pcBfbH1XAxJtOdom8fGEdjUE7l51G5SCEdTOmFqox9pt6n
         oswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=0VQuOBOAInh/oCFmAgnHFTRx83AeymR8zc8R+S3NTFU=;
        b=YhMH68vqZm4KQGdDFycU3bcIOWf26q2ij0aJJnJHl+NtfhqQkWvV+4JJrzdBvEwLkv
         0UZ40iJUMRB6BZCl1LBJzZXVet9J8QHpxrXe5qMa/GMmdfxSHtdQDeIeIr5fKjNorKG6
         Zvs7lQjl/VOjkvP9kNOED2yWt9VW9RPBPFfFuc041RiEdILW/L2uxTY4V3XfK7gbBtzz
         M/qWN0K+iFicPgwFn45lRIhUCuW4h82cqykiCi7WmueJ2R+rYm5QAV8TDdKi8bgq0js6
         2XEStnraC+gPXs2rgAplnheCkU+d2X8T/t8SeIEiNvhjo8zLgue+KNt22e5neTDS3BwG
         sEPQ==
X-Gm-Message-State: ACrzQf3AXXsd9SHlmsIyeIY1GJS4XCqoLdI2oFckN+FgvOl/4zrQjxc1
        11k3fQLjZIF2cQhhh2EibZQT+If1xZKgBMbrnnU=
X-Google-Smtp-Source: AMsMyM7cEOYu5ehiOXv8FBAWRTs8M1hxnMSvPRjGav3ZMWFIiXRKmaZiCb+7gfTiJdgtVXryB8GNHQElsTJGk+ROFw4=
X-Received: by 2002:a25:2441:0:b0:6ae:bb37:3db3 with SMTP id
 k62-20020a252441000000b006aebb373db3mr15315384ybk.213.1663596579877; Mon, 19
 Sep 2022 07:09:39 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7000:1845:b0:3ba:c80e:5a6f with HTTP; Mon, 19 Sep 2022
 07:09:39 -0700 (PDT)
Reply-To: davidbeames02@gmail.com
From:   David Beames <info.globalreourceaid021@gmail.com>
Date:   Mon, 19 Sep 2022 16:09:39 +0200
Message-ID: <CAFjUfKME5KBcUryb+vP06UGjwrjNrU-MyKuNt6MKvMYJsLFsgg@mail.gmail.com>
Subject: REF/UPDATE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNCLAIMED_MONEY,UNDISC_FREEM
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [info.globalreourceaid021[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [davidbeames02[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [info.globalreourceaid021[at]gmail.com]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:b2f listed in]
        [list.dnswl.org]
        *  2.4 UNCLAIMED_MONEY BODY: People just leave money laying around
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day

Reply by Email to confirm names, last name, and phone number,
in-respect to an unclaimed Fund in our claims file record,

Yours Sincerely,
David Beames
