Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64D3314EEB2
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728976AbgAaOqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 09:46:05 -0500
Received: from mail-yw1-f50.google.com ([209.85.161.50]:43767 "EHLO
        mail-yw1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgAaOqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 09:46:05 -0500
Received: by mail-yw1-f50.google.com with SMTP id f204so3858391ywc.10
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 06:46:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XMKbcmoSnQAXlW2AyN0LyNlTk+lpyFHLJPBhiXon0Rs=;
        b=PvAw/SlaIQRI6vx+Ay9buECYRrAYUEOJPXpNb6gdYSE5t9tvbbQVNxbfOK/ipAiPwC
         Z2dF9wWxlz67dexQ6SRizgaR3tJ654Gsq142zhUPw+CFoJPx8GaPRjWr0XjufXlfdI3b
         O9Y5PVGf2jusPJ1jvlgL2ke93ArH5ZiyIByc02mnWseu+1GaRWh/KrieMxmXGduqaEyC
         me0xcexjysVATi9OuUo56H+VLmNBMqHMritjWYh6Ly6A3MboCOiw3oPqvExXeZDoXKYO
         ucoJGaPSbho1QdsvSlWLVLn3wfKPDKZosaQPSVzZNhsBlNdZ4iHiCBw2ist3Igj+siaE
         gYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMKbcmoSnQAXlW2AyN0LyNlTk+lpyFHLJPBhiXon0Rs=;
        b=Kkxn5pSqRZwT4N2p2KMvec9F0SFgA1PW6VAzVd23tCzJylZ8Lqp9/cwVLIW7MjUs6T
         pZeky7jjMqoq5KjsZWoD87G+SOBhyhkKKGsF6FBtAo/S5uW6Y0gr7yPooYwtwanYT26s
         d2oXjuM9rI3O4eHwoa2b3ZB9DLyN30kKQWk8LelFwx15EjHTbO5PMh2GNVxIwpMlJB/q
         jHV+lbBK8zDaKEXJzUADPxOkGqmWTRVEmJFnsbi/+0nmD55j6cOxwe041ew1Noh+Kf0U
         okB5qesKQlP9h/YKsXOCHVvZciuItg2E+Bgh2kNo+iexBcuo11kJ9+/Dh9v9zygRvj81
         a8FQ==
X-Gm-Message-State: APjAAAVSZldIWjoqy6BL8qy4JvfU12HGu7gnjz4Haakizg2osrT0xKLl
        ifrTGo/5I2vcKVjZRaHsXVbBCMYOu4PWOPx31FY=
X-Google-Smtp-Source: APXvYqyx9WKpSOKrVVRkMqgV4GjlexH5e8D7tCzt/jUaGa3uqsDLuWiYxPno6xmWLmr6qYdFJUeXGMeeIQ9Aul4PFUM=
X-Received: by 2002:a25:6144:: with SMTP id v65mr8552085ybb.61.1580481964284;
 Fri, 31 Jan 2020 06:46:04 -0800 (PST)
MIME-Version: 1.0
References: <CAJx5YvHH9CoC8ZDz+MwG8RFr3eg2OtDvmU-EaqG76CiAz+W+5Q@mail.gmail.com>
 <20200130085629.42c71fdf@cakuba>
In-Reply-To: <20200130085629.42c71fdf@cakuba>
From:   Martin T <m4rtntns@gmail.com>
Date:   Fri, 31 Jan 2020 16:45:50 +0200
Message-ID: <CAJx5YvFDeTo9vvFLNX8AdRCc2mFmcphxWnO54a3s5PQSh7gRjQ@mail.gmail.com>
Subject: Re: Why is NIC driver queue depth driver dependent when it allocates
 system memory?
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> the idea is that drivers can choose the initial setting which are
> optimal for the implementation and the hardware. Whether they actually
> are, or whether values chosen 10 years ago for tg3 and e1000e are
> reasonable for modern uses of that hardware could perhaps be questioned.

Ok, thanks!


Martin
