Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED408113AF5
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 05:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728560AbfLEEwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 23:52:44 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46646 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728470AbfLEEwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 23:52:44 -0500
Received: by mail-wr1-f68.google.com with SMTP id z7so1780083wrl.13
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 20:52:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B5sfQpsHKh2QB3Sdsg9g8xt9BSrdeqtW5cDa7uviUSM=;
        b=QtsB3ZmTwC+PjkcW0uuEC2a50tMO4cnkBRyz7JEyZEnAsSAaSAaNH2igQTZ8uzPRQD
         iG3dzKHTSJVYJosQp1xotCfK3+WROhNTvKd+AzdwP1+edeT7SCEVCisTgCxZnGGl5Qvh
         iPLdeOimK8VI7Vlxnn5HS0HaprLGdVKp89oDPMMryF3wRv4bwNgwlLpIYf05ZGSFH5sH
         hEvMQlkBlNhzPsxQ2OcPasXWjevndWdtqfd8m13LJuZ1mgC075EiXAtf820NFCN0LTrs
         0WIQNHYNJ77bvDQ8Ra6pztE7n+h55jPeJSFTYdgA1mfAWNaZWWYU49Q+a2/PwrfEc1gR
         CdQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B5sfQpsHKh2QB3Sdsg9g8xt9BSrdeqtW5cDa7uviUSM=;
        b=dMX1xjBCKHEtD+wRdvN1f/AUmVQpC9LUGcjnMlWjSvxj7FMj06lLFHAk0x7zAZyrJj
         ehDZndwqT0SyHjgd2+AV2ASLgTIrTbJebppHDD92QmCcmdUuDrDWmLSGnYOy/iENzzWc
         eNyDLpsO0TLBBn8EX7+YBk2htkqJsocwkVxputD9O1dMfPZ9E1p+YCl2bVIs47w2AVmI
         UlMGx+eMsCa3rmwSNtykpdUui6GyHLzz9WmM36Sbto2K3kUFndzBFlaYiwmLU+EAUnnL
         bpUl1WZS8xKvMwzCfSm7opBPU7RlsdEM95qQCfLqY+hCu0wpFjtS3ZoBxOwA8/1SvsZY
         t9hQ==
X-Gm-Message-State: APjAAAVBNIl7K0e4D4d11dtIL20Yi0AK/eHZfqD0q3kfixYTh5owOqSm
        mCLcGGj9y2voA5QdeQ7P771FiiqZk2NMBIqgUcU=
X-Google-Smtp-Source: APXvYqxKUHIGZDRZCpGilxnSfsedrUQ66VDbMGNSi0Er3kJn24T+3LaRIGMeVISQibh0+aMUP4WokXK2+xBXIrG9NSQ=
X-Received: by 2002:adf:f885:: with SMTP id u5mr7842156wrp.359.1575521561975;
 Wed, 04 Dec 2019 20:52:41 -0800 (PST)
MIME-Version: 1.0
References: <20191126115807.27843-1-gautamramk@gmail.com> <20191204105943.5423f535@hermes.lan>
In-Reply-To: <20191204105943.5423f535@hermes.lan>
From:   Leslie Monis <lesliemonis@gmail.com>
Date:   Thu, 5 Dec 2019 10:22:05 +0530
Message-ID: <CAHv+uoFak0v4pkLw9W=-v9zTq2TWRtiFE675vneJZ3g-_KYWuA@mail.gmail.com>
Subject: Re: [PATCH iproute2] tc: pie: add dq_rate_estimator option
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Gautam Ramakrishnan <gautamramk@gmail.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On Thu, Dec 5, 2019 at 12:29 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
> Note: pie and several other qdisc need to be fixed to support
> JSON and oneline output format.

Thanks for the feedback. We'll work on this right away.

Leslie
