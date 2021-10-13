Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B6F42B7AB
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbhJMGmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:42:10 -0400
Received: from mout.gmx.net ([212.227.15.19]:34385 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhJMGmJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 02:42:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1634107201;
        bh=zFLOaCZY9OZJewyXKTCOyBw8pCf/U2NtvYUplyt9V2U=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=eZ7uEbBmnuOWj5sGN4pkRBTAUlNmHLGIr5No8lJGTZOFPQYCQkK8DEDBpJPnZbxP9
         ExT7CHC6gWZZ9xDwsLsYXKcsfge/4ZsOgDk3LKq6CuIyD0pi7ShSWvMXZWSuEPMyRZ
         +n5fXR0Ii/YkO71B1hdFpdlMN87N+biLtIvpAZ40=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from homer.fritz.box ([185.221.148.85]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mqs4Z-1n5hlR3bHN-00mqbV; Wed, 13
 Oct 2021 08:40:00 +0200
Message-ID: <ceb1282d98a436e7cddea6af8641f272867ab326.camel@gmx.de>
Subject: Re: [bisected] Re: odd NFS v4.2 regression 4.4..5.15
From:   Mike Galbraith <efault@gmx.de>
To:     netdev <netdev@vger.kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust <trond.myklebust@primarydata.com>
Date:   Wed, 13 Oct 2021 08:39:59 +0200
In-Reply-To: <0100fc6eb38b745f45cc614cee30f332c1b6456d.camel@gmx.de>
References: <0367ae6905b13851d3b8494ea8f2465bcd9c3ded.camel@gmx.de>
         <0100fc6eb38b745f45cc614cee30f332c1b6456d.camel@gmx.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.0 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:d8xRxlDhcmkh0FH7SY437O8dARS/LuEA1XxtU63yOWMfv5cYtDQ
 W5mhb26YhyxtHgm9wp7zNqfPjEEjZu9GdhT+Jl0PvFsLNRC4CtlJVTHV9brxizd2XXeGbDb
 76AA/pJv7PAAD6HJk8KxCCBuNH8BlEAhE8ovCvdCmrNBEQgo62iHREh5ts3OzYYd/tqduR8
 zFRYFcMS+OwKfwnYNw8Ug==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:oUNagmQKPS8=:7hp2TkiQ8DCcC+5wxwLURI
 ntYlQ/hy5qPfftNoMfaCyoCexZFGjDcm4uSMhs8x5RoBb2iI6Nkz+cWrU+YTPThvx0XW7kssD
 y3FncJHvgDUU7EGl6UkXoAioa4DCLB4FzxS3eEbH+GYyrTelz5OMIZYvCnsi+vGoEsRF19CgX
 nwFKbGNZbUv9OIsxsVvyX5bXmJ6Fl2n2onjaVX88629xWRMNIKidvkqY97tSxF8zHbD+/MfyW
 3CejVAjbaG8x+SV3bgdRFp4x39MVQXmBPTL63d8iYA7TcNjef4YLYzV1VLDPPsR0LuUYAjcND
 yGjx9hlYC9gW7hAx1lhGFLLf0qqrvPNUbqZC7vQHyCXnLgPiyXYLPREILDhVIMkBknIBTVqKU
 5tPt+UqF8NBvXg/qPv2RTZe01Ex9c7juBADUc/KEjh20vKea7CQ6jmAk24R7ZKMkiwWR5MP4w
 6JykN4V7/15EyPh1yxB3SpBOaSsLpXBJuYeEoQXfdyXTWOONoefmQThWc35OPJkQO5ZzoPKPa
 66ZrhUgwk21sPMikOEtuxW9hyEaXYAA3jDJd6pf97Jhjye1jDrkL0ts+wUVCoZrwtX5RJC9T8
 gvN8ggD1bFTQiz3frFrcDJJEM+8M46fQOv1vbk8RTtXhsCMqwJ/MDVE9fZiCDX2iIxQW30wBv
 YyFlcNe7W35WuIdWRLM9ExMLCUwaV/OZpIXVX99N3fGboNIpXjtyI4qsYE1zIA2Iau8VqPgDU
 zW63TmVDKUu+JPKF7OG6EKfQ2dzlaQbrGLGK8SK6hXMb/GHWFQfxgWgGt+7dMX+0bbmOBVUDr
 2KbfjyTMz1L2qRVBWki3eiNPonG5/LBvrIJH3xqlFuiLusJhairs3BpASZ2AMoZoCWyZDBLxq
 AMQbOT+BHoJNrJtOFGaTDYAlyKXORtDGPNQb2DILv9d5BawG8JYFj82fnqIM9PrHYwYZOVoeb
 JakdrjiN2ueGNf3tIH2S2D6U93QO0VdXy89lE83ucv/PsOf2iHey1UCH2DzycwS/ASN1NeB80
 N//PS1qVnZaTqKUJcEFodBKZeXuIb/W+VuOYiiGdMqDB3x5nx0eg/CwqYAZyscn2NTRHx7qBr
 ZDD1oZzXdmSrlU=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[replaces bouncy address]

On Wed, 2021-10-13 at 08:35 +0200, Mike Galbraith wrote:
> On Tue, 2021-10-12 at 15:54 +0200, Mike Galbraith wrote:
> > Greetings network wizards,
> >
> > I seem to have stumbled across a kind of odd looking NFS regression
> > while looking at something unrelated.
> >
> > I have a few VMs that are mirrors of my desktop box, including some
> > data, but they usually over-mount directories with tons of data via
> > NFS, thus hang off the host like a mini-me Siamese twin for testing.
> >
> > In the data below, I run a script in git-daemon's home to extract RT
> > patch sets with git-format-patch, on the host for reference, on the
> > host in an NFS mount of itself, and the mini-me VM, where I started.
> >
> > Note: bonnie throughput looked fine for v4.2.
> >
> > host
> > time su - git -c ./format-rt-patches.sh
> > real=C2=A0=C2=A0=C2=A0 1m5.923s
> > user=C2=A0=C2=A0=C2=A0 0m54.692s
> > sys=C2=A0=C2=A0=C2=A0=C2=A0 0m11.550s
> >
> > NFS mount my own box, and do the same from the same spot
> > time su git -c 'cd /homer/home/git;./format-rt-patches.sh'
> >
> > 4.4.231=C2=A0=C2=A0=C2=A0=C2=A0 v4.2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 v3
> > 1=C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0 2m27.046s=C2=A0=C2=A0 2m2.059s
> > =C2=A0=C2=A0=C2=A0 user=C2=A0=C2=A0=C2=A0 0m59.190s=C2=A0=C2=A0 0m58.7=
01s
> > =C2=A0=C2=A0=C2=A0 sys=C2=A0=C2=A0=C2=A0=C2=A0 0m41.448s=C2=A0=C2=A0 0=
m32.541s
> >
> > 5.15-rc5=C2=A0=C2=A0=C2=A0 v4.2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 v3
> > =C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0=C2=A0 3m14.954s=C2=A0=C2=A0 2m8.36=
6s
> > =C2=A0=C2=A0 user=C2=A0=C2=A0=C2=A0=C2=A0 0m59.901s=C2=A0=C2=A0 0m58.3=
17s
> > =C2=A0=C2=A0 sys=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0m52.708s=C2=A0=C2=A0 0=
m32.313s
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 vs 1=C2=A0=C2=A0 0.754=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0.951
> >
> > repeats=C2=A0=C2=A0=C2=A0=C2=A0 v4.2=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 v3
> > =C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0=C2=A0 3m16.313s=C2=A0=C2=A0 2m7.94=
0s
> > =C2=A0=C2=A0 real=C2=A0=C2=A0=C2=A0=C2=A0 3m10.905s=C2=A0=C2=A0 2m8.02=
9s
>
> Found the v4.2 regression (for this load anyway) to have landed in 5.4.
> It then bisected cleanly to either the build bug or its neighbor.
>
> There are only 'skip'ped commits left to test.
> The first bad commit could be any of:
> fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189
> eb82dd393744107ebc365a53e7813c7c67cb203b
> We cannot bisect more!
>
> git bisect start
> # good: [4d856f72c10ecb060868ed10ff1b1453943fc6c8] Linux 5.3
> git bisect good 4d856f72c10ecb060868ed10ff1b1453943fc6c8
> # bad: [219d54332a09e8d8741c1e1982f5eae56099de85] Linux 5.4
> git bisect bad 219d54332a09e8d8741c1e1982f5eae56099de85
> # good: [a9f8b38a071b468276a243ea3ea5a0636e848cf2] Merge tag 'for-linus-=
5.4-1' of git://github.com/cminyard/linux-ipmi
> git bisect good a9f8b38a071b468276a243ea3ea5a0636e848cf2
> # good: [5825a95fe92566ada2292a65de030850b5cff1da] Merge tag 'selinux-pr=
-20190917' of git://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/selinu=
x
> git bisect good 5825a95fe92566ada2292a65de030850b5cff1da
> # bad: [48acba989ed5d8707500193048d6c4c5945d5f43] Merge tag 'riscv/for-v=
5.4-rc3' of git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux
> git bisect bad 48acba989ed5d8707500193048d6c4c5945d5f43
> # good: [7bccb9f10c8f36ee791769b531ed4d28f6379aae] Merge tag 'linux-watc=
hdog-5.4-rc1' of git://www.linux-watchdog.org/linux-watchdog
> git bisect good 7bccb9f10c8f36ee791769b531ed4d28f6379aae
> # bad: [ef129d34149ea23d0d442844fc25ae26a85589fc] selftests/net: add net=
test to .gitignore
> git bisect bad ef129d34149ea23d0d442844fc25ae26a85589fc
> # bad: [9c5efe9ae7df78600c0ee7bcce27516eb687fa6e] Merge branch 'sched-ur=
gent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect bad 9c5efe9ae7df78600c0ee7bcce27516eb687fa6e
> # good: [8bbe0dec38e147a50e9dd5f585295f7e68e0f2d0] Merge tag 'for-linus'=
 of git://git.kernel.org/pub/scm/virt/kvm/kvm
> git bisect good 8bbe0dec38e147a50e9dd5f585295f7e68e0f2d0
> # bad: [298fb76a5583900a155d387efaf37a8b39e5dea2] Merge tag 'nfsd-5.4' o=
f git://linux-nfs.org/~bfields/linux
> git bisect bad 298fb76a5583900a155d387efaf37a8b39e5dea2
> # bad: [bbf2f098838aa86cee240a7a11486e0601d56a3f] nfsd: Reset the boot v=
erifier on all write I/O errors
> git bisect bad bbf2f098838aa86cee240a7a11486e0601d56a3f
> # skip: [fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189] nfsd: convert nfs4_fi=
le->fi_fds array to use nfsd_files
> git bisect skip fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189
> # bad: [5e113224c17e2fb156b785ddbbc48a0209fddb0c] nfsd: nfsd_file cache =
entries should be per net namespace
> git bisect bad 5e113224c17e2fb156b785ddbbc48a0209fddb0c
> # good: [48cd7b51258c1a158293cefb97dda988080f5e13] nfsd: hook up nfsd_re=
ad to the nfsd_file cache
> git bisect good 48cd7b51258c1a158293cefb97dda988080f5e13
> # bad: [501cb1849f865960501d19d54e6a5af306f9b6fd] nfsd: rip out the rapa=
rms cache
> git bisect bad 501cb1849f865960501d19d54e6a5af306f9b6fd
> # bad: [eb82dd393744107ebc365a53e7813c7c67cb203b] nfsd: convert fi_deleg=
_file and ls_file fields to nfsd_file
> git bisect bad eb82dd393744107ebc365a53e7813c7c67cb203b
> # good: [5920afa3c85ff38642f652b6e3880e79392fcc89] nfsd: hook nfsd_commi=
t up to the nfsd_file cache
> git bisect good 5920afa3c85ff38642f652b6e3880e79392fcc89
> # only skipped commits left to test
> # possible first bad commit: [eb82dd393744107ebc365a53e7813c7c67cb203b] =
nfsd: convert fi_deleg_file and ls_file fields to nfsd_file
> # possible first bad commit: [fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189] =
nfsd: convert nfs4_file->fi_fds array to use nfsd_files
> # good: [5920afa3c85ff38642f652b6e3880e79392fcc89] nfsd: hook nfsd_commi=
t up to the nfsd_file cache
> git bisect good 5920afa3c85ff38642f652b6e3880e79392fcc89
> # only skipped commits left to test
> # possible first bad commit: [eb82dd393744107ebc365a53e7813c7c67cb203b] =
nfsd: convert fi_deleg_file and ls_file fields to nfsd_file
> # possible first bad commit: [fd4f83fd7dfb1bce2f1af51fcbaf6575f4b9d189] =
nfsd: convert nfs4_file->fi_fds array to use nfsd_files
>
>

