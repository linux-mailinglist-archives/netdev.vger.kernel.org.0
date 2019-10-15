Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DB3D8478
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 01:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390259AbfJOX2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 19:28:18 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38398 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbfJOX2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 19:28:17 -0400
Received: by mail-lf1-f65.google.com with SMTP id u28so15823123lfc.5
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 16:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9RGZ2dB5vFko61D8/va89aqMdIfzwPuKvy5GvV/ERyw=;
        b=h411lAJ3ui+f1GbODHa8bDpBFdSRG++wGJCxOBbRkdqt0O5htNOn67yrMlDuLyuou+
         fePFOpT8A/mNU9G5OHQRo9z1p8dcgVVXN5AuYmdAItq9QMnl9u7B0huysMj8+GZ6yGwd
         mH8IBH72b+Mg5pqysePPU8PKkY6mnWiYlkUbIFkN0txQZ1YMGVlfozPngtOGD/lZruyp
         H4wfcW9xiQ3IWom7i7CcutSnyLdS9fYPnWNFysGnP1XfL8Q6Z/Q6D4UU56K/eMaEsO1/
         HCqAsBFJZVY8TVsSHal6kLExfFoXvfCqM0/83tOkt3TeCm3pZeFEnNXBfJ7Kcyl/ZgEI
         UKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9RGZ2dB5vFko61D8/va89aqMdIfzwPuKvy5GvV/ERyw=;
        b=rW7VCIwWlPzzpw1A5+GjVt55Gvm8zJ8g/q3pDZidie8aC8wlUu1b6EZncwyvxlc9kP
         BthFkDP7c7UTtj72dJhum1KSvIcKMGRcRXa8S5d033dYG87qCh7jMZDUhXQQsPPberto
         lzBfZ7hdTHuSWhwyvr0MbGTd+71BBFFLedpTfZ44E2CSZRCy8liVr2WI88hVQ4x/AVhg
         ZqKfaLMKn489BbtXsCq777mBGJGNZkslMNmresRluLxk51+6b9gOscP0JHtLRrsfiCWx
         nbpdYGBQQUJEBfqbMBwiw56Mqar1enNjkxQWob6IjJefDjBR4Z8LOe1JcPlGay3aIR1J
         OdTQ==
X-Gm-Message-State: APjAAAVnA2o+1jV0E8yZNPXUieZcI+MPmOXNBxIaJqSh/oq7z/3xODpi
        2WGgawvqhJ2dHimQgJPFNOMlnzyMswrcVHndyZg=
X-Google-Smtp-Source: APXvYqymLL/j1mTy2/CO7QOxMh2JlCRE/QrzRbyRJ/jJ/tEJQqr3+6LvK8ovYP/wjzq+1tPtPSomyx2dNT46G8ZAgeE=
X-Received: by 2002:a19:f80d:: with SMTP id a13mr21158382lff.6.1571182094472;
 Tue, 15 Oct 2019 16:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <20191015100057.19199-1-jiri@resnulli.us> <20191015083530.0bd551d4@cakuba.netronome.com>
In-Reply-To: <20191015083530.0bd551d4@cakuba.netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 15 Oct 2019 16:28:02 -0700
Message-ID: <CAADnVQJBzQLVgxFaOv9Jba=tyZNB4RmskWyTA6dAWnH7ATZFcg@mail.gmail.com>
Subject: Re: [patch net-next] selftests: bpf: don't try to read files without
 read permission
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        kernel test robot <rong.a.chen@intel.com>, mlxsw@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 8:35 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Tue, 15 Oct 2019 12:00:56 +0200, Jiri Pirko wrote:
> > From: Jiri Pirko <jiri@mellanox.com>
> >
> > Recently couple of files that are write only were added to netdevsim
> > debugfs. Don't read these files and avoid error.
> >
> > Reported-by: kernel test robot <rong.a.chen@intel.com>
> > Signed-off-by: Jiri Pirko <jiri@mellanox.com>
>
> Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied. Thanks
