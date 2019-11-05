Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABC51F0579
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 19:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390840AbfKES4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 13:56:04 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46796 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390651AbfKES4E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 13:56:04 -0500
Received: by mail-il1-f195.google.com with SMTP id m16so19167735iln.13;
        Tue, 05 Nov 2019 10:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=Q4QMP1XKSjtkVM9T6Z5fSOGqwrDB5TCfhLz+dELwQ+M=;
        b=ECg4WObD2x2JVp7Q91KmRUxmu26g5kseXwPnkE4USkqv5SUYIjOtTfYRO1rGdmH+XX
         6rwKUe2tZe0eobzgVNVKhHztwi0zXxE/nrHcEPWinEyLwNPGPGCJznGUIxsRItZ4tL4f
         r/GZps/9xCOznJoYQ7W1UlR45+8NrtZvpSxboQ4ZRIWXq9CRmdIgGouhUlsDo1Jb5DS5
         XuH7/zrwE/CFoW9//Wd6q+dfuE42/iPjU0vfzm/OySXDxLmFMKKCSCIL+IEJOZIHBmgs
         PuffsEZZAmswbvqCpLUq5TU+2rxfXRqH9e8aCt9xViO3AELEqO+XlHKLdYINhvOGrQrf
         UbIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=Q4QMP1XKSjtkVM9T6Z5fSOGqwrDB5TCfhLz+dELwQ+M=;
        b=GF2joOmxA+uODKhQ8SGBA+NNw6iSqq/JSFWinLajp8zwKG1ie6E3SQoKaRUMzUJipV
         +jYticGYld0WNcbHCONU+f5QYvJCEy89eHIPT2T5K4LoViW3/EZTy68UXtLF9Noe/w8n
         E8uBIAueTT6ZqnVFHDG8/LmPuLOC41gGWr51j22VboYCcjkYsn51/y7O7L0xqe2BhjL2
         RiEegsmxsAg4AuXnQ0Fm0xg6r765V1g7BZ33QvHB45LqPiR2EnfV9hPTG7UBHkHA/P8e
         10/ocMiljKJrD92uQ3nZpo6DfgIoYF9o4Vn8zL59cC0VMGfQc2H22uaEiCKrbUGSoN5Z
         Os3Q==
X-Gm-Message-State: APjAAAVbC9YuUl+O5hE4GTIlCpqsFLQR6w1nv+ye/NYMbC6o7/9zN3fk
        JOi2M0hZx2CO390y1lzGzsdmpiji8h+2sK3fVKdiJA==
X-Google-Smtp-Source: APXvYqwQF6NW94QxUEE3/jn49LPRcb14vjzeddmSTd9hwdvv8wms+Aj2diAx+RQ622y8YYEClNbbgdw/dGTgJUhfEwM=
X-Received: by 2002:a92:7e18:: with SMTP id z24mr15707410ilc.276.1572980162440;
 Tue, 05 Nov 2019 10:56:02 -0800 (PST)
MIME-Version: 1.0
References: <CAHCN7xJiJKBgkiRm-MF9NpgQqfV4=zSVRShc5Sb5Lya2TAxU0g@mail.gmail.com>
In-Reply-To: <CAHCN7xJiJKBgkiRm-MF9NpgQqfV4=zSVRShc5Sb5Lya2TAxU0g@mail.gmail.com>
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 5 Nov 2019 12:55:51 -0600
Message-ID: <CAHCN7xK0Y7=Wr9Kq02CWCbQjWVOocU02LLEB=QsVB22yNNoQPw@mail.gmail.com>
Subject: Re: Long Delay on startup of wl18xx Wireless chip
To:     Linux-OMAP <linux-omap@vger.kernel.org>, kvalo@codeaurora.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 12:25 PM Adam Ford <aford173@gmail.com> wrote:
>
> I am seeing a really long delay at startup of the wl18xx using the 5.4 ke=
rnel.
>

Sorry I had to resend.  I forgot to do plaintext.  Google switched
settings on me and neglected to inform me.


> [    7.895551] wl18xx_driver wl18xx.2.auto: Direct firmware load for ti-c=
onnectivity/wl18xx-conf.bin failed with error -2
> [    7.906416] wl18xx_driver wl18xx.2.auto: Falling back to sysfs fallbac=
k for: ti-connectivity/wl18xx-conf.bin
>
> At this point in the sequence, I can login to Linux, but the WL18xx is un=
available.
>
> [   35.032382] vwl1837: disabling
> [   69.594874] wlcore: ERROR could not get configuration binary ti-connec=
tivity/wl18xx-conf.bin: -11
> [   69.604013] wlcore: WARNING falling back to default config
> [   70.174821] wlcore: wl18xx HW: 183x or 180x, PG 2.2 (ROM 0x11)
> [   70.189003] wlcore: WARNING Detected unconfigured mac address in nvs, =
derive from fuse instead.
> [   70.197851] wlcore: WARNING This default nvs file can be removed from =
the file system
> [   70.218816] wlcore: loaded
>
> It is now at this point when the wl18xx is available.
>
> I have the wl18xx and wlcore setup as a module so it should load after th=
e filesystem is mounted.  I am not using a wl18xx-conf.bin, but I never nee=
ded to use this before.
>
> It seems to me unreasonable to wait 60+ seconds after everything is mount=
ed for the wireless chip to become available.  Before I attempt to bisect t=
his, I was hoping someone might have seen this.  I am also trying to avoid =
duplicating someone else's efforts.
>
> I know the 4.19 doesn't behave like this.
>
> adam
