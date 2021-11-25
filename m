Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EAC245D669
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 09:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349985AbhKYIr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 03:47:27 -0500
Received: from mout.gmx.net ([212.227.15.19]:51651 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350303AbhKYIp0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 03:45:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1637829717;
        bh=pTBKhOyNHo2kd9wSXTLWZDdipub3XoU4TTwUPdwtYiU=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=IDSV5F+OB8hZ9TjN4R2UHeKilWHDCh61dsxNvBQxFX0UB5nHcT3KEzC8xDTO6akb7
         5N4qtvrJPzvwV/0/fhUFIUV58uzmt99OEHXHnvHZuI2YWprbuD1GTWi4lPvL6BXXXa
         6kDojIAhFuX305iPrsJ67j5f8bpaA+cu1Qe9IZP0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from machineone.fritz.box ([84.190.129.26]) by mail.gmx.net
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MWics-1n9wEv2IcC-00X0fE; Thu, 25 Nov 2021 09:41:57 +0100
Message-ID: <227af6b0692a0a57f5fb349d4d9c914301753209.camel@gmx.de>
Subject: Re: [REGRESSION] Kernel 5.15 reboots / freezes upon ifup/ifdown
From:   Stefan Dietrich <roots@gmx.de>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, regressions@lists.linux.dev,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org
Date:   Thu, 25 Nov 2021 09:41:56 +0100
In-Reply-To: <87a6htm4aj.fsf@intel.com>
References: <924175a188159f4e03bd69908a91e606b574139b.camel@gmx.de>
         <YZ3q4OKhU2EPPttE@kroah.com>
         <8119066974f099aa11f08a4dad3653ac0ba32cd6.camel@gmx.de>
         <20211124153449.72c9cfcd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <87a6htm4aj.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:DaD3+CAquwpZFLYcwk/TovClM5KKeW5kQ3vzBln9DLhtfHOJM+9
 XjpuSu3uJglb1+b+26AgREaZr7gyqgM08EqOqNz2lfUYvTQU+TfKoulgcBTjjrbdafMTmTK
 8J1xH5g/c4ljWFFwLgNPfk4lipjkhSciYkaPD+5HmNP1hOd50iFjv5ek8EktrolLSRoXM1W
 KXLlnvujjxyyZ1ufBAing==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:dYqWouehDqQ=:G00neIJZvNjnP66DW/vhaT
 8ToLECEo3VTe+Bb8zotzAMxuZXt86K9HTYe/tuewGl0Kw7jqX1k0JVYVQZTPMH/5iSvLoUl9D
 zcW+ozwR8XYOwBFqo7C/Zwx1UaCdW3P/xpSVdUM9N2nLhBQyGVZREaIYGcC1TJfioBsIsn5gZ
 E/uDQZcrqVgxMmeLnEO5cRduymAmkJ4owZzJUqJPN9IiJKaRyiPFEmQ8l5Gy/CTad1DKHqlXa
 sn202lRbtGnPitA2oayxrJ51T2WhcKX9aVtBMXg1I6qqZjEKDE02dI9ORMTqPlI4iU+4TC+YT
 4/qCk6OStStLJW8njUs/jaD7sPdFeN/JYLHn7SD2WGAnreP4+I1DVd+Qet1diFMNtxk2/Fl1e
 zDt1RjUNiVaxAEGyNXjcROyFZwumefX4IZOJDIQEABc+iLEGXd2DszRpOBirex/a4PzU41PWk
 oXfkgFrBGIlxr/0PvVWj+jcMnhNr9XAyH6pSVbHR0YU6TpJtVIwdB7CxJPOEdki6eDc0DArQs
 ahvToTqexNrjFv6rOWiB1h9RKY5vgyJtMdkjoNAfqLILW28hP+OWqJYnAk70bwLghYnovX71v
 qY6no770XX358gIcuFqJeF1KlplAzYKim07IYYbhJyEdqPufPKS3dcuC9XsxqSJ+C04T1lpeT
 krrIgj/PI6R4Y8N0xQ6m6/LXkwYy4R9zAvEvCfvY3ZZYmmDqqFjIS2i//73EG/qo3mMRZclT7
 jW/Gqyxzw77k4HJgbZinqeITG2HQEWTjnAAN1EGV4LHNTZpWgv5ry9f0NGQi4rIQBfbLsD1Go
 TAnNVO3l628JN3ZLICp0HBOw03gfp1RHRwCT1qqdw2Wc25jzW6+7W4JR6W+CA2ZxbRbFl54+E
 Ylf/dHVravMNEzAXM26Gb0Txb1r3H0BJ4LYwj+wI0818slCB5GhHRBXlJpOY67yFvfuYbobRW
 VQB+OKsozLZ5bNKM0Rd/A9K/EnCyXq93ZMhfiz6zmyWb7uvF573ijR3nyxHZ00sYArzhcMGbZ
 S77i1c/mrVNFBpXlGgSevN+Ih6gGpnNDLW4h9tvlX2bNPHxa7JCw4RmpeC/lmimUznRmaNQtL
 RGC9og+wEgxX7o=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

thanks - this was spot-on: disabling CONFIG_PCIE_PTM resolves the issue
for latest 5.15.4 (stable from git) for both manual and network-manager
NIC configuration.

Let me know if I may assist in debugging this further.


Cheers,
Stefan


On Wed, 2021-11-24 at 17:07 -0800, Vinicius Costa Gomes wrote:
> Hi Stefan,
>
> Jakub Kicinski <kuba@kernel.org> writes:
>
> > On Wed, 24 Nov 2021 18:20:40 +0100 Stefan Dietrich wrote:
> > > Hi all,
> > >
> > > six exciting hours and a lot of learning later, here it is.
> > > Symptomatically, the critical commit appears for me between
> > > 5.14.21-
> > > 051421-generic and 5.15.0-051500rc2-generic - I did not find an
> > > amd64
> > > build for rc1.
> > >
> > > Please see the git-bisect output below and let me know how I may
> > > further assist in debugging!
> >
> > Well, let's CC those involved, shall we? :)
> >
> > Thanks for working thru the bisection!
> >
> > > a90ec84837325df4b9a6798c2cc0df202b5680bd is the first bad commit
> > > commit a90ec84837325df4b9a6798c2cc0df202b5680bd
> > > Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > > Date:   Mon Jul 26 20:36:57 2021 -0700
> > >
> > >     igc: Add support for PTP getcrosststamp()
>
> Oh! That's interesting.
>
> Can you try disabling CONFIG_PCIE_PTM in your kernel config? If it
> works, then it's a point in favor that this commit is indeed the
> problematic one.
>
> I am still trying to think of what could be causing the lockup you
> are
> seeing.
>
>
> Cheers,

