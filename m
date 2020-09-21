Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38967272158
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 12:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIUKjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 06:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgIUKjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 06:39:02 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE5AC0613CF
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:39:02 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id w2so11619186wmi.1
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 03:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=815PefS5zvLdQ7D87NKa1eSJ5I4DKxCbFZlXVdIOiew=;
        b=eQiynjUNa7H0ULRmDBn/a9gnNuhDfWsTWCJzx5pS9vux/WaRo1DEPXu26YMdh4Cx3a
         CWkOoeocK+6Py8imhk3uoyCHsLib5VjbmE22WZzyrcsJm8/6hgIkHcnGHxRluFy0BdCk
         GJhz/lbWKod0B9cLnO9CjSWFyVmfV26bD5etc0LWY+YlafqDIkFzRvEslDZzZyWiAkom
         npHe2tM5x88sTK/MT9C33JCLxtIEOFm/6fCcXemsxaDdI7oqbbMEV60xzQC4z1GUMdjb
         Pb1nYP94BTsXLGvBaUiEfkU0op8Am1yc4MpJk/+Gfxp5ZgNI800vV0EYZ4aCjoEGSVar
         vp0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=815PefS5zvLdQ7D87NKa1eSJ5I4DKxCbFZlXVdIOiew=;
        b=DM6U0wu3Ps7QJ4t1nt5Vzp6wbEFTdzIe2STu7gFnwF+kpUdEh6VRAGu0EFaVyGFc8C
         3WS0inGbbnoe/ZJ3141o7SdrA95SoikZUY3AZspQ8iju6IB5fU/Kyaap7aL9ELULUBHH
         HszjhtHMU08TbhF5vlPrA0gq1jmLQVHoK0bTlLsKMExMqS69VPnn6WQGzyzatl9njWzv
         atEARUu/jJ9fnN+04NCrA3yuf687VQSVklLHABCTBwEgMbPoyZbkQRdTpLphk0WO8PZn
         cr/uxEVfhSzoj3QXnBD3yTKhqnGDpNN/yl9xq/DnmrLxH0csDdD6SWDF2Yr12uxAUu7C
         3oMw==
X-Gm-Message-State: AOAM531pOqgA2L1ef3sj+kd4IhE5On08g5HFKS1WSt7tIgxEtURHfTKP
        607Fyc/ko5SbtIMP8t8J7ScFU1+NrWpNDCH6P88DZQ==
X-Google-Smtp-Source: ABdhPJzGiKn4/m3XDfI6z8LGN97TpSTsbqM0u5nqJgInWKx46kgonkJngPqqxfKd6ZnRUb7KWNJ5cFDusvxlFjTdMWM=
X-Received: by 2002:a7b:c0c5:: with SMTP id s5mr29004793wmh.152.1600684740821;
 Mon, 21 Sep 2020 03:39:00 -0700 (PDT)
MIME-Version: 1.0
References: <1600328501-8832-1-git-send-email-amit.pundir@linaro.org> <20200917160513.GO1893@yoga>
In-Reply-To: <20200917160513.GO1893@yoga>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Mon, 21 Sep 2020 16:08:24 +0530
Message-ID: <CAMi1Hd0S+hOLL0X8=_1KGG0G7u0bt66H6=yN=LuuX+FJb8+-4g@mail.gmail.com>
Subject: Re: [PATCH] ath10k: qmi: Skip host capability request for Xiaomi Poco F1
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeffrey Hugo <jeffrey.l.hugo@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Konrad Dybcio <konradybcio@gmail.com>,
        ath10k <ath10k@lists.infradead.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 at 21:35, Bjorn Andersson
<bjorn.andersson@linaro.org> wrote:
>
> On Thu 17 Sep 02:41 CDT 2020, Amit Pundir wrote:
>
> > Workaround to get WiFi working on Xiaomi Poco F1 (sdm845)
> > phone. We get a non-fatal QMI_ERR_MALFORMED_MSG_V01 error
> > message in ath10k_qmi_host_cap_send_sync(), but we can still
> > bring up WiFi services successfully on AOSP if we ignore it.
> >
> > We suspect either the host cap is not implemented or there
> > may be firmware specific issues. Firmware version is
> > QC_IMAGE_VERSION_STRING=WLAN.HL.2.0.c3-00257-QCAHLSWMTPLZ-1
> >
> > qcom,snoc-host-cap-8bit-quirk didn't help. If I use this
> > quirk, then the host capability request does get accepted,
> > but we run into fatal "msa info req rejected" error and
> > WiFi interface doesn't come up.
> >
>
> What happens if you skip sending the host-cap message? I had one
> firmware version for which I implemented a
> "qcom,snoc-host-cap-skip-quirk".
>
> But testing showed that the link was pretty unusable - pushing any real
> amount of data would cause it to silently stop working - and I realized
> that I could use the linux-firmware wlanmdsp.mbn instead, which works
> great on all my devices...

I skipped the ath10k_qmi_host_cap_send_sync block altogether
(if that is what you meant by qcom,snoc-host-cap-skip-quirk) and
so far did not run into any issues with youtube auto-playback loop
(3+ hours and counting). Does that count as a valid use case?
Otherwise let me know how could I reproduce a reasonable test
setup?

>
> > Attempts are being made to debug the failure reasons but no
> > luck so far. Hence this device specific workaround instead
> > of checking for QMI_ERR_MALFORMED_MSG_V01 error message.
> > Tried ath10k/WCN3990/hw1.0/wlanmdsp.mbn from the upstream
> > linux-firmware project but it didn't help and neither did
> > building board-2.bin file from stock bdwlan* files.
> >
>
> "Didn't work" as in the wlanmdsp.mbn from linux-firmware failed to load
> or some laer problem?

While using the wlanmdsp.mbn from linux-firmware, I run into
the following crash 4 times before tqftpserv service gets killed
eventually:

[   46.504502] qcom-q6v5-mss 4080000.remoteproc: fatal error received:
dog_virtual_root.c:89:User-PD grace timer expired for wlan_process
(ASID: 1)
[   46.504527] remoteproc remoteproc0: crash detected in
4080000.remoteproc: type fatal error
[   46.504558] remoteproc remoteproc0: handling crash #1 in 4080000.remoteproc
[   46.504563] remoteproc remoteproc0: recovering 4080000.remoteproc
[   56.542400] 4080000.remoteproc:glink-edge: intent request timed out
[   56.644617] qcom-q6v5-mss 4080000.remoteproc: port failed halt
[   56.652321] remoteproc remoteproc0: stopped remote processor
4080000.remoteproc
[   59.017963] qcom-q6v5-mss 4080000.remoteproc: MBA booted without
debug policy, loading mpss
[   61.514552] remoteproc remoteproc0: remote processor
4080000.remoteproc is now up
<.... snip ....>
[  214.161946] failed to send del client cmd
[  214.161952] failed while handling packet from 1:16689
[  214.185826] failed to send del client cmd
[  214.185832] failed while handling packet from 1:16688
[  214.201951] failed to send del client cmd
<.... snip ....>
[  219.682148] failed to send del client cmd
[  219.682154] failed while handling packet from 1:16394
[  219.714707] init: Service 'tqftpserv' (pid 321) received signal 6
oneshot service took 215.852005 seconds in background
[  219.714754] init: Sending signal 9 to service 'tqftpserv' (pid 321)
process group...

Regards,
Amit Pundir

>
> Regards,
> Bjorn
>
> > This workaround will be removed once we have a viable fix.
> > Thanks to postmarketOS guys for catching this.
> >
> > Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
> > ---
> > Device-tree for Xiaomi Poco F1(Beryllium) got merged in
> > qcom/arm64-for-5.10 last week
> > https://git.kernel.org/pub/scm/linux/kernel/git/qcom/linux.git/commit/?id=77809cf74a8c
> >
> >  drivers/net/wireless/ath/ath10k/qmi.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> > index 0dee1353d395..37c5350eb8b1 100644
> > --- a/drivers/net/wireless/ath/ath10k/qmi.c
> > +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> > @@ -651,7 +651,8 @@ static int ath10k_qmi_host_cap_send_sync(struct ath10k_qmi *qmi)
> >
> >       /* older FW didn't support this request, which is not fatal */
> >       if (resp.resp.result != QMI_RESULT_SUCCESS_V01 &&
> > -         resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01) {
> > +         resp.resp.error != QMI_ERR_NOT_SUPPORTED_V01 &&
> > +         !of_machine_is_compatible("xiaomi,beryllium")) { /* Xiaomi Poco F1 workaround */
> >               ath10k_err(ar, "host capability request rejected: %d\n", resp.resp.error);
> >               ret = -EINVAL;
> >               goto out;
> > --
> > 2.7.4
> >
