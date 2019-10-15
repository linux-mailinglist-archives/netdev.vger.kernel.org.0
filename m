Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0165D731A
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbfJOKXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:23:53 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40902 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727810AbfJOKXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 06:23:53 -0400
Received: by mail-qk1-f196.google.com with SMTP id y144so18619715qkb.7
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 03:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EiFTh2EPuAUilSBW5ORtAUE6MmP+CQvo3ee4BGaXRP8=;
        b=U45dslVBzK6iRCuucnnbxu4+GCuSzO3Ei/0ucSX4K8EjANTVkf+iAPpMN6gwUCsgbo
         WmN2/0o4wBrGPENc7soFUzNydyHN9ikjkH8Sem6xPn5EzKId+TdO5I9lcSoD2pdW7rqe
         z09CkC8vjZLHYFE1wb6DZjaOVNuhScy8HgKqEC03WzclEbfJ3AoJMNBkkiQy0S15jjAT
         WnOSonWmS0HGUY93F0brGMrQfhdIa3cglZn1wh+WCWJmT4MU3g9L5J69YbosFrW6THnv
         l8pdVRF1Z2hXBaDs0xlvyiWKYv0QyvrfYFp2Xh+WBT1t/mnobB13ND8ciCtwT78Y3n5Z
         tjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EiFTh2EPuAUilSBW5ORtAUE6MmP+CQvo3ee4BGaXRP8=;
        b=haKYQAPj7+MMR4/iHjoXHHAhT5f4uR2t4Evi2YchKH6XVqBcI8DAUDCVFF1FTOwjBy
         q8XBnOkosouDzCUQhBM1mPho9UtMh7s0IBBUbCd2+WBFGEQXqkKLCucrb6Nq+VQgcHAW
         E4cvAyfi3J1TO1+mlAPGuiu5nIpsebDxTMsHlFur6d+agzCGuoMCRNYGNIcj4I4siwsb
         pC/3wbOR1sh4Jrek9BBENd98vc1s5oA4UnFenzwT0yjsGX1W0Mp4L/019y8nKqCBScBF
         aZ8+rWGIzVB+Gndt54nkZp9Jo2UGGQ1sCnv9jSSBIW5hKh0kJMH+Ootk8j3JF3z6H9m8
         WiNg==
X-Gm-Message-State: APjAAAWpQaZD5ipJYSHWbOujeokGCBI8wSQ/ALp8rKIYulToNR68plht
        B9haR+DcqZD+UMw6wvM6pnWERTggNOUIA28/mLDNMg==
X-Google-Smtp-Source: APXvYqzGTN80R3a4qRjY873LTjorS2tyON7Y6AGjgssje3QxI7bcUcplUcJW2iGLhsDqXnHFEVIKcGyQzcQzDeMU+j4=
X-Received: by 2002:a37:5f46:: with SMTP id t67mr33208312qkb.220.1571135032293;
 Tue, 15 Oct 2019 03:23:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191015101608.4566-1-chiu@endlessm.com>
In-Reply-To: <20191015101608.4566-1-chiu@endlessm.com>
From:   Chris Chiu <chiu@endlessm.com>
Date:   Tue, 15 Oct 2019 18:23:41 +0800
Message-ID: <CAB4CAwecqN5G348+OW0k=h_QaKahTo_Mb9E+pFCP=GjTLJjpMA@mail.gmail.com>
Subject: Re: [PATCH] rtl8xxxu: fix connection failure issue after warm reboot
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        David Miller <davem@davemloft.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 6:16 PM Chris Chiu <chiu@endlessm.com> wrote:
>
> ---
> 2.23.0
>
Please ignore this message since it's not properly titled and no
detail description.
Sorry for inconvenience.

Chris
