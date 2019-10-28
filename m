Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A088E72E0
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 14:51:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389149AbfJ1NvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 09:51:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:38123 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbfJ1NvM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 09:51:12 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 06:51:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,240,1569308400"; 
   d="txt'?scan'208";a="224634587"
Received: from irsmsx109.ger.corp.intel.com ([163.33.3.23])
  by fmsmga004.fm.intel.com with ESMTP; 28 Oct 2019 06:51:10 -0700
Received: from irsmsx103.ger.corp.intel.com ([169.254.3.139]) by
 IRSMSX109.ger.corp.intel.com ([169.254.13.52]) with mapi id 14.03.0439.000;
 Mon, 28 Oct 2019 13:51:08 +0000
From:   "Grubba, Arkadiusz" <arkadiusz.grubba@intel.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Michael, Alice" <alice.michael@intel.com>
Subject: RE: [net-next 02/11] i40e: Add ability to display VF stats along
 with PF core stats
Thread-Topic: [net-next 02/11] i40e: Add ability to display VF stats along
 with PF core stats
Thread-Index: AQHVic8dTcWXJbIkn0yxskZAxwkmSqdpFYyAgAcBTnA=
Date:   Mon, 28 Oct 2019 13:51:07 +0000
Deferred-Delivery: Mon, 28 Oct 2019 13:50:25 +0000
Message-ID: <35C27A066ED4844F952811E08E4D95090D398A32@IRSMSX103.ger.corp.intel.com>
References: <20191023182426.13233-1-jeffrey.t.kirsher@intel.com>
        <20191023182426.13233-3-jeffrey.t.kirsher@intel.com>
 <20191023204149.4ae25f90@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191023204149.4ae25f90@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDk1YWE5NmEtZjdkMy00ODJhLTk2YjYtMmZiODhjNzc1NzY1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicHB5cmtNcVRmeUdZaCtqWFVLdURNNDRLenlFdW1DdnNkUTM0Y1NPRUZGQjhDYVgxVDFWM3dDdUtLU0dEdkdpSyJ9
x-ctpclassification: CTP_NT
x-originating-ip: [163.33.239.182]
Content-Type: multipart/mixed;
        boundary="_002_35C27A066ED4844F952811E08E4D95090D398A32IRSMSX103gercor_"
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_35C27A066ED4844F952811E08E4D95090D398A32IRSMSX103gercor_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Hi,

The main info about _what_ and _why_ , as you wrote, is explained in the fi=
rst (i.e. title) line.
Namely, this change was introduced to "Add ability to display VF stats alon=
g with PF core stats" (for i40e equipment as prefix "i40e:" stands for it i=
n the title).

(And if it was about general issues, i.e. why we introduce such changes, th=
en, of course, they usually result mostly from the needs reported, e.g. by =
users using a given solution, although this does not change the nature/sign=
ificance of the change from a technical point of view.)

As for further comments, that's right, you rightly notice here that the bas=
ic VF statistics are displayed and there may actually be an alternative pos=
sibility to check them (or other, newer solutions may appear that may enabl=
e it). The solution introduced here is simply one of the options (and maybe=
 also the basis for further development of it).
But I don't know exactly for what specific purpose you mention it here?
What is the question? ...
(but for sure, if I guess right what you would like to ask, it's good to ke=
ep in mind that no tool is perfectly well in itself to the full extent of a=
ll use cases or... preferences - that's why we have alternatives and genera=
lly good to have them.)

[But also, such considerations already fall, for example, into the area of =
user preferences. And of course, the role of this patch is not to want to i=
nfluence someone's preferences but only to provide some opportunity (as opp=
osed to limiting the possibility of using various solutions, which should p=
robably not be our goal...)
because among others here, this particular change is to be made available i=
n connection with the exact and targeted needs raised by the users of the e=
quipment affected by this code.]

As for the last point, this is indeed some oversight - yes, the last senten=
ce is now unnecessary after rearranging this patch to meet the final requir=
ements / agreements for the upstream (in-tree) version of it (as I also men=
tioned in my previous email - see attachment).
I think that instead of this last sentence in the commit message discussed =
here, and if you think it is important here, we may add (copy) from the ori=
ginal commit message this part of the text regarding description of display=
ed statistics:

+Testing hints:
+
+Use ethtool -S with this PF interface and check the output.
+Extra lines with the prefix "vf" should be displayed, e.g.:
+"
+     vf012.rx_bytes: 69264721849
+     vf012.rx_unicast: 45629259
+     vf012.rx_multicast: 9
+     vf012.rx_broadcast: 1
+     vf012.rx_discards: 2958
+     vf012.rx_unknown_protocol: 0
+     vf012.tx_bytes: 93048734
+     vf012.tx_unicast: 1409700
+     vf012.tx_multicast: 11
+     vf012.tx_broadcast: 0
+     vf012.tx_discards: 0
+     vf012.tx_errors: 0
+"
+(it's an example of a whole stats block for one VF).
+
+(For more specific tests:
+Create some VF interfaces, link them and give them IP addresses.
+Generate same network traffic and then follow the instructions above.)


(but for me it's really not certain whether in this particular case a large=
r description means better, especially since it is not so important from th=
e point of view of the functioning of the kernel / driver or the system or =
interaction with them.)

Best Regards
A.G.


-----Original Message-----
From: Jakub Kicinski [mailto:jakub.kicinski@netronome.com] =

Sent: Thursday, October 24, 2019 5:42 AM
To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
Cc: davem@davemloft.net; Grubba, Arkadiusz <arkadiusz.grubba@intel.com>; ne=
tdev@vger.kernel.org; nhorman@redhat.com; sassmann@redhat.com; Bowers, Andr=
ewX <andrewx.bowers@intel.com>
Subject: Re: [net-next 02/11] i40e: Add ability to display VF stats along w=
ith PF core stats

On Wed, 23 Oct 2019 11:24:17 -0700, Jeff Kirsher wrote:
> From: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
> =

> This change introduces the ability to display extended (enhanced) =

> statistics for PF interfaces.
> =

> The patch introduces new arrays defined for these extra stats (in =

> i40e_ethtool.c file) and enhances/extends ethtool ops functions =

> intended for dealing with PF stats (i.e.: i40e_get_stats_count(), =

> i40e_get_ethtool_stats(), i40e_get_stat_strings() ).

This commit message doesn't explain _what_ stats your adding, and _why_.

From glancing at the code you're dumping 128 * 12 stats, which are basic ne=
tdev stats per-VF. =


These are trivially exposed on representors in modern designs.

> There have also been introduced the new build flag named =

> "I40E_PF_EXTRA_STATS_OFF" to exclude from the driver code all code =

> snippets associated with these extra stats.

And this doesn't even exist in the patch.

> Signed-off-by: Arkadiusz Grubba <arkadiusz.grubba@intel.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

--------------------------------------------------------------------

Intel Technology Poland sp. z o.o.
ul. Slowackiego 173 | 80-298 Gdansk | Sad Rejonowy Gdansk Polnoc | VII Wydz=
ial Gospodarczy Krajowego Rejestru Sadowego - KRS 101882 | NIP 957-07-52-31=
6 | Kapital zakladowy 200.000 PLN.

Ta wiadomosc wraz z zalacznikami jest przeznaczona dla okreslonego adresata=
 i moze zawierac informacje poufne. W razie przypadkowego otrzymania tej wi=
adomosci, prosimy o powiadomienie nadawcy oraz trwale jej usuniecie; jakiek=
olwiek
przegladanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the s=
ole use of the intended recipient(s). If you are not the intended recipient=
, please contact the sender and delete all copies; any review or distributi=
on by
others is strictly prohibited.

--_002_35C27A066ED4844F952811E08E4D95090D398A32IRSMSX103gercor_
Content-Type: text/plain; name="email.txt"
Content-Description: email.txt
Content-Disposition: attachment; filename="email.txt"; size=9983;
	creation-date="Mon, 28 Oct 2019 13:44:23 GMT";
	modification-date="Mon, 28 Oct 2019 13:44:23 GMT"
Content-Transfer-Encoding: base64

RnJvbTogR3J1YmJhLCBBcmthZGl1c3ogDQpTZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIgMTAsIDIw
MTkgMTE6NTggUE0NClRvOiBNaWNoYWVsLCBBbGljZSA8YWxpY2UubWljaGFlbEBpbnRlbC5jb20+
OyBlMTAwMC1wYXRjaGVzQGVjbGlzdHMuaW50ZWwuY29tDQpTdWJqZWN0OiBSRTogW2UxMDAwLXBh
dGNoZXNdIFtuZXh0IFBBVENIIFMxMCAwMi8xMV0gaTQwZTogQWRkIGFiaWxpdHkgdG8gZGlzcGxh
eSBWRiBzdGF0cyBhbG9uZyB3aXRoIFBGIGNvcmUgc3RhdHMNCg0KSGkgQWxpY2UsDQoNClRoZSBs
YXN0IHNlbnRlbmNlIGluIHRoZSBjb21taXQgbWVzc2FnZSBzaG91bGQgYmUgZGVsZXRlZCBiZWNh
dXNlIGl0IGlzIHVubmVjZXNzYXJ5L3VucmVsYXRlZCB0byB0aGlzIHBhcnRpY3VsYXIgY2FzZS4g
KEkgbWVhbiB0aGUgc2VudGVuY2UgYWJvdXQgdGhlIGJ1aWxkIGZsYWcuKSBBbmQgb3JpZ2luYWxs
eSB0aGVyZSB3YXMgYWxzbyBhIGNvbW1lbnQgKGZpdmUgbGluZXMpIHRvIHRoZSBjb2RlIGluIHRo
ZSBmdW5jdGlvbiBpNDBlX2dldF9zdGF0c19jb3VudCgpIC4uLg0KQXBhcnQgZnJvbSB0aGlzLCBB
Q0suDQoNClRoYW5rcw0KQXJlaw0KDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpGcm9t
OiBlMTAwMC1wYXRjaGVzLXJlcXVlc3RAZWNsaXN0cy5pbnRlbC5jb20gW21haWx0bzplMTAwMC1w
YXRjaGVzLXJlcXVlc3RAZWNsaXN0cy5pbnRlbC5jb21dIE9uIEJlaGFsZiBPZiBNaWNoYWVsLCBB
bGljZQ0KU2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDEwLCAyMDE5IDEwOjAwIFBNDQpUbzogTWlj
aGFlbCwgQWxpY2UgPGFsaWNlLm1pY2hhZWxAaW50ZWwuY29tPjsgZTEwMDAtcGF0Y2hlc0BlY2xp
c3RzLmludGVsLmNvbQ0KQ2M6IEdydWJiYSwgQXJrYWRpdXN6IDxhcmthZGl1c3ouZ3J1YmJhQGlu
dGVsLmNvbT4NClN1YmplY3Q6IFtlMTAwMC1wYXRjaGVzXSBbbmV4dCBQQVRDSCBTMTAgMDIvMTFd
IGk0MGU6IEFkZCBhYmlsaXR5IHRvIGRpc3BsYXkgVkYgc3RhdHMgYWxvbmcgd2l0aCBQRiBjb3Jl
IHN0YXRzDQoNCkZyb206IEFya2FkaXVzeiBHcnViYmEgPGFya2FkaXVzei5ncnViYmFAaW50ZWwu
Y29tPg0KDQpUaGlzIGNoYW5nZSBpbnRyb2R1Y2VzIHRoZSBhYmlsaXR5IHRvIGRpc3BsYXkgZXh0
ZW5kZWQgKGVuaGFuY2VkKSBzdGF0aXN0aWNzIGZvciBQRiBpbnRlcmZhY2VzIChpbiBhY2NvcmRh
bmNlIHRvIHRoZSBuZXcgYnVpbGQgZmxhZ3MgYWxzbyBpbnRyb2R1Y2VkIGhlcmUpLg0KDQpUaGUg
cGF0Y2ggaW50cm9kdWNlcyBuZXcgYXJyYXlzIGFuZCBwcmVwcm9jZXNzb3Igc3ltYm9scyBkZWZp
bmVkIGZvciB0aGVzZSBleHRyYSBzdGF0cyAoaW4gaTQwZV9ldGh0b29sLmMgZmlsZSkgYW5kIGVu
aGFuY2VzL2V4dGVuZHMgZXRodG9vbCBvcHMgZnVuY3Rpb25zIGludGVuZGVkIGZvciBkZWFsaW5n
IHdpdGggUEYgc3RhdHMgKGkuZS46IGk0MGVfZ2V0X3N0YXRzX2NvdW50KCksIGk0MGVfZ2V0X2V0
aHRvb2xfc3RhdHMoKSwgaTQwZV9nZXRfc3RhdF9zdHJpbmdzKCkgKS4NCg0KVGhlcmUgaGF2ZSBh
bHNvIGJlZW4gaW50cm9kdWNlZCB0aGUgbmV3IGJ1aWxkIGZsYWcgbmFtZWQgIkk0MEVfUEZfRVhU
UkFfU1RBVFNfT0ZGIiB0byBleGNsdWRlIGZyb20gdGhlIGRyaXZlciBjb2RlIGFsbCBjb2RlIHNu
aXBwZXRzIGFzc29jaWF0ZWQgd2l0aCB0aGVzZSBleHRyYSBzdGF0cy4NCg0KU2lnbmVkLW9mZi1i
eTogQXJrYWRpdXN6IEdydWJiYSA8YXJrYWRpdXN6LmdydWJiYUBpbnRlbC5jb20+DQotLS0NCiAu
Li4vbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9ldGh0b29sLmMgICAgfCAxNDkgKysrKysr
KysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQsIDE0OSBpbnNlcnRpb25zKCspDQoNCmRpZmYg
LS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfZXRodG9vbC5jIGIv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX2V0aHRvb2wuYw0KaW5kZXggNDFl
MTI0MGFjYWVhLi5jODE0Yzc1NmI0YmIgMTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9pbnRlbC9pNDBlL2k0MGVfZXRodG9vbC5jDQorKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pNDBlL2k0MGVfZXRodG9vbC5jDQpAQCAtMzg5LDYgKzM4OSw3IEBAIHN0YXRpYyBjb25z
dCBzdHJ1Y3QgaTQwZV9zdGF0cyBpNDBlX2dzdHJpbmdzX3BmY19zdGF0c1tdID0gew0KIA0KICNk
ZWZpbmUgSTQwRV9HTE9CQUxfU1RBVFNfTEVOCUFSUkFZX1NJWkUoaTQwZV9nc3RyaW5nc19zdGF0
cykNCiANCisvKiBMZW5ndGggKG51bWJlcikgb2YgUEYgY29yZSBzdGF0cyBvbmx5IChpLmUuIHdp
dGhvdXQgcXVldWVzIC8gZXh0cmENCitzdGF0cyk6ICovDQogI2RlZmluZSBJNDBFX1BGX1NUQVRT
X0xFTgkoSTQwRV9HTE9CQUxfU1RBVFNfTEVOICsgXA0KIAkJCQkgSTQwRV9QRkNfU1RBVFNfTEVO
ICsgXA0KIAkJCQkgSTQwRV9WRUJfU1RBVFNfTEVOICsgXA0KQEAgLTM5Nyw2ICszOTgsNDQgQEAg
c3RhdGljIGNvbnN0IHN0cnVjdCBpNDBlX3N0YXRzIGk0MGVfZ3N0cmluZ3NfcGZjX3N0YXRzW10g
PSB7DQogLyogTGVuZ3RoIG9mIHN0YXRzIGZvciBhIHNpbmdsZSBxdWV1ZSAqLw0KICNkZWZpbmUg
STQwRV9RVUVVRV9TVEFUU19MRU4JQVJSQVlfU0laRShpNDBlX2dzdHJpbmdzX3F1ZXVlX3N0YXRz
KQ0KIA0KKyNkZWZpbmUgSTQwRV9TVEFUU19OQU1FX1ZGSURfRVhUUkEgInZmX19fLiINCisjZGVm
aW5lIEk0MEVfU1RBVFNfTkFNRV9WRklEX0VYVFJBX0xFTg0KKyhzaXplb2YoSTQwRV9TVEFUU19O
QU1FX1ZGSURfRVhUUkEpIC0gMSkNCisNCitzdGF0aWMgc3RydWN0IGk0MGVfc3RhdHMgaTQwZV9n
c3RyaW5nc19ldGhfc3RhdHNfZXh0cmFbXSA9IHsNCisJSTQwRV9WU0lfU1RBVChJNDBFX1NUQVRT
X05BTUVfVkZJRF9FWFRSQQ0KKwkJICAgICAgInJ4X2J5dGVzIiwgZXRoX3N0YXRzLnJ4X2J5dGVz
KSwNCisJSTQwRV9WU0lfU1RBVChJNDBFX1NUQVRTX05BTUVfVkZJRF9FWFRSQQ0KKwkJICAgICAg
InJ4X3VuaWNhc3QiLCBldGhfc3RhdHMucnhfdW5pY2FzdCksDQorCUk0MEVfVlNJX1NUQVQoSTQw
RV9TVEFUU19OQU1FX1ZGSURfRVhUUkENCisJCSAgICAgICJyeF9tdWx0aWNhc3QiLCBldGhfc3Rh
dHMucnhfbXVsdGljYXN0KSwNCisJSTQwRV9WU0lfU1RBVChJNDBFX1NUQVRTX05BTUVfVkZJRF9F
WFRSQQ0KKwkJICAgICAgInJ4X2Jyb2FkY2FzdCIsIGV0aF9zdGF0cy5yeF9icm9hZGNhc3QpLA0K
KwlJNDBFX1ZTSV9TVEFUKEk0MEVfU1RBVFNfTkFNRV9WRklEX0VYVFJBDQorCQkgICAgICAicnhf
ZGlzY2FyZHMiLCBldGhfc3RhdHMucnhfZGlzY2FyZHMpLA0KKwlJNDBFX1ZTSV9TVEFUKEk0MEVf
U1RBVFNfTkFNRV9WRklEX0VYVFJBDQorCQkgICAgICAicnhfdW5rbm93bl9wcm90b2NvbCIsIGV0
aF9zdGF0cy5yeF91bmtub3duX3Byb3RvY29sKSwNCisJSTQwRV9WU0lfU1RBVChJNDBFX1NUQVRT
X05BTUVfVkZJRF9FWFRSQQ0KKwkJICAgICAgInR4X2J5dGVzIiwgZXRoX3N0YXRzLnR4X2J5dGVz
KSwNCisJSTQwRV9WU0lfU1RBVChJNDBFX1NUQVRTX05BTUVfVkZJRF9FWFRSQQ0KKwkJICAgICAg
InR4X3VuaWNhc3QiLCBldGhfc3RhdHMudHhfdW5pY2FzdCksDQorCUk0MEVfVlNJX1NUQVQoSTQw
RV9TVEFUU19OQU1FX1ZGSURfRVhUUkENCisJCSAgICAgICJ0eF9tdWx0aWNhc3QiLCBldGhfc3Rh
dHMudHhfbXVsdGljYXN0KSwNCisJSTQwRV9WU0lfU1RBVChJNDBFX1NUQVRTX05BTUVfVkZJRF9F
WFRSQQ0KKwkJICAgICAgInR4X2Jyb2FkY2FzdCIsIGV0aF9zdGF0cy50eF9icm9hZGNhc3QpLA0K
KwlJNDBFX1ZTSV9TVEFUKEk0MEVfU1RBVFNfTkFNRV9WRklEX0VYVFJBDQorCQkgICAgICAidHhf
ZGlzY2FyZHMiLCBldGhfc3RhdHMudHhfZGlzY2FyZHMpLA0KKwlJNDBFX1ZTSV9TVEFUKEk0MEVf
U1RBVFNfTkFNRV9WRklEX0VYVFJBDQorCQkgICAgICAidHhfZXJyb3JzIiwgZXRoX3N0YXRzLnR4
X2Vycm9ycyksIH07DQorDQorI2RlZmluZSBJNDBFX1NUQVRTX0VYVFJBX0NPVU5UCTEyOCAgLyog
YXMgZm9yIG5vdyBvbmx5IEk0MEVfTUFYX1ZGX0NPVU5UICovDQorLyogRm9sbG93aW5nIGxlbmd0
aCB2YWx1ZSBkb2VzIG5vdCBpbmNsdWRlIHRoZSBsZW5ndGggdmFsdWVzIGZvciBxdWV1ZXMgc3Rh
dHMgKi8NCisjZGVmaW5lIEk0MEVfU1RBVFNfRVhUUkFfTEVOCUFSUkFZX1NJWkUoaTQwZV9nc3Ry
aW5nc19ldGhfc3RhdHNfZXh0cmEpDQorLyogTGVuZ3RoIChudW1iZXIpIG9mIFBGIGV4dHJhIHN0
YXRzIG9ubHkgKGkuZS4gd2l0aG91dCBjb3JlIHN0YXRzIC8NCitxdWV1ZXMpOiAqLyAjZGVmaW5l
IEk0MEVfUEZfU1RBVFNfRVhUUkFfTEVOIChJNDBFX1NUQVRTX0VYVFJBX0NPVU5UICoNCitJNDBF
X1NUQVRTX0VYVFJBX0xFTikNCisvKiBMZW5ndGggKG51bWJlcikgb2YgZW5oYW5jZWQvYWxsIFBG
IHN0YXRzIChpLmUuIGNvcmUgd2l0aCBleHRyYQ0KK3N0YXRzKTogKi8gI2RlZmluZSBJNDBFX1BG
X1NUQVRTX0VOSEFOQ0VfTEVOIChJNDBFX1BGX1NUQVRTX0xFTiArDQorSTQwRV9QRl9TVEFUU19F
WFRSQV9MRU4pDQorDQogZW51bSBpNDBlX2V0aHRvb2xfdGVzdF9pZCB7DQogCUk0MEVfRVRIX1RF
U1RfUkVHID0gMCwNCiAJSTQwRV9FVEhfVEVTVF9FRVBST00sDQpAQCAtMjE5MCw2ICsyMjI5LDkg
QEAgc3RhdGljIGludCBpNDBlX2dldF9zdGF0c19jb3VudChzdHJ1Y3QgbmV0X2RldmljZSAqbmV0
ZGV2KQ0KIAkgKi8NCiAJc3RhdHNfbGVuICs9IEk0MEVfUVVFVUVfU1RBVFNfTEVOICogMiAqIG5l
dGRldi0+bnVtX3R4X3F1ZXVlczsNCiANCisJaWYgKHZzaSA9PSBwZi0+dnNpW3BmLT5sYW5fdnNp
XSAmJiBwZi0+aHcucGFydGl0aW9uX2lkID09IDEpDQorCQlzdGF0c19sZW4gKz0gSTQwRV9QRl9T
VEFUU19FWFRSQV9MRU47DQorDQogCXJldHVybiBzdGF0c19sZW47DQogfQ0KIA0KQEAgLTIyNTgs
NiArMjMwMCwxMCBAQCBzdGF0aWMgdm9pZCBpNDBlX2dldF9ldGh0b29sX3N0YXRzKHN0cnVjdCBu
ZXRfZGV2aWNlICpuZXRkZXYsDQogCXN0cnVjdCBpNDBlX3ZzaSAqdnNpID0gbnAtPnZzaTsNCiAJ
c3RydWN0IGk0MGVfcGYgKnBmID0gdnNpLT5iYWNrOw0KIAlzdHJ1Y3QgaTQwZV92ZWIgKnZlYiA9
IE5VTEw7DQorCXVuc2lnbmVkIGludCB2c2lfaWR4Ow0KKwl1bnNpZ25lZCBpbnQgdmZfaWR4Ow0K
Kwl1bnNpZ25lZCBpbnQgdmZfaWQ7DQorCWJvb2wgaXNfdmZfdmFsaWQ7DQogCXVuc2lnbmVkIGlu
dCBpOw0KIAlib29sIHZlYl9zdGF0czsNCiAJdTY0ICpwID0gZGF0YTsNCkBAIC0yMzA3LDExICsy
MzUzLDEwOSBAQCBzdGF0aWMgdm9pZCBpNDBlX2dldF9ldGh0b29sX3N0YXRzKHN0cnVjdCBuZXRf
ZGV2aWNlICpuZXRkZXYsDQogCQlpNDBlX2FkZF9ldGh0b29sX3N0YXRzKCZkYXRhLCAmcGZjLCBp
NDBlX2dzdHJpbmdzX3BmY19zdGF0cyk7DQogCX0NCiANCisJLyogQXMgZm9yIG5vdywgd2Ugb25s
eSBwcm9jZXNzIHRoZSBTUklPViB0eXBlIFZTSXMgKGFzIGV4dHJhIHN0YXRzIHRvDQorCSAqIFBG
IGNvcmUgc3RhdHMpIHdoaWNoIGFyZSBjb3JyZWxhdGVkIHdpdGggVkYgTEFOIFZTSSAoaGVuY2Ug
YmVsb3csDQorCSAqIGluIHRoaXMgZm9yLWxvb3AgaW5zdHJ1Y3Rpb24gYmxvY2ssIG9ubHkgVkYn
cyBMQU4gVlNJcyBhcmUgY3VycmVudGx5DQorCSAqIHByb2Nlc3NlZCkuDQorCSAqLw0KKwlmb3Ig
KHZmX2lkID0gMDsgdmZfaWQgPCBwZi0+bnVtX2FsbG9jX3ZmczsgdmZfaWQrKykgew0KKwkJaXNf
dmZfdmFsaWQgPSB0cnVlOw0KKwkJZm9yICh2Zl9pZHggPSAwOyB2Zl9pZHggPCBwZi0+bnVtX2Fs
bG9jX3ZmczsgdmZfaWR4KyspDQorCQkJaWYgKHBmLT52Zlt2Zl9pZHhdLnZmX2lkID09IHZmX2lk
KQ0KKwkJCQlicmVhazsNCisJCWlmICh2Zl9pZHggPj0gcGYtPm51bV9hbGxvY192ZnMpIHsNCisJ
CQlkZXZfaW5mbygmcGYtPnBkZXYtPmRldiwNCisJCQkJICJJbiB0aGUgUEYncyBhcnJheSwgdGhl
cmUgaXMgbm8gVkYgaW5zdGFuY2Ugd2l0aCBWRl9JRCBpZGVudGlmaWVyICVkIG9yIGl0IGlzIG5v
dCBzZXQvaW5pdGlhbGl6ZWQgY29ycmVjdGx5IHlldFxuIiwNCisJCQkJIHZmX2lkKTsNCisJCQlp
c192Zl92YWxpZCA9IGZhbHNlOw0KKwkJCWdvdG8gY2hlY2tfdmY7DQorCQl9DQorCQl2c2lfaWR4
ID0gcGYtPnZmW3ZmX2lkeF0ubGFuX3ZzaV9pZHg7DQorDQorCQl2c2kgPSBwZi0+dnNpW3ZzaV9p
ZHhdOw0KKwkJaWYgKCF2c2kpIHsNCisJCQkvKiBJdCBtZWFucyBlbXB0eSBmaWVsZCBpbiB0aGUg
UEYgVlNJIGFycmF5Li4uICovDQorCQkJZGV2X2luZm8oJnBmLT5wZGV2LT5kZXYsDQorCQkJCSAi
Tm8gTEFOIFZTSSBpbnN0YW5jZSByZWZlcmVuY2VkIGJ5IFZGICVkIG9yIGl0IGlzIG5vdCBzZXQv
aW5pdGlhbGl6ZWQgY29ycmVjdGx5IHlldFxuIiwNCisJCQkJIHZmX2lkKTsNCisJCQlpc192Zl92
YWxpZCA9IGZhbHNlOw0KKwkJCWdvdG8gY2hlY2tfdmY7DQorCQl9DQorCQlpZiAodnNpLT52Zl9p
ZCAhPSB2Zl9pZCkgew0KKwkJCWRldl9pbmZvKCZwZi0+cGRldi0+ZGV2LA0KKwkJCQkgIkluIHRo
ZSBQRidzIGFycmF5LCB0aGVyZSBpcyBpbmNvcnJlY3RseSBzZXQvaW5pdGlhbGl6ZWQgTEFOIFZT
SSBvciByZWZlcmVuY2UgdG8gaXQgZnJvbSBWRiAlZCBpcyBub3Qgc2V0L2luaXRpYWxpemVkIGNv
cnJlY3RseSB5ZXRcbiIsDQorCQkJCSB2Zl9pZCk7DQorCQkJaXNfdmZfdmFsaWQgPSBmYWxzZTsN
CisJCQlnb3RvIGNoZWNrX3ZmOw0KKwkJfQ0KKwkJaWYgKHZzaS0+dmZfaWQgIT0gcGYtPnZmW3Zm
X2lkeF0udmZfaWQgfHwNCisJCSAgICAhaTQwZV9maW5kX3ZzaV9mcm9tX2lkKHBmLCBwZi0+dmZb
dnNpLT52Zl9pZF0ubGFuX3ZzaV9pZCkpIHsNCisJCQkvKiBEaXNqb2ludGVkIGlkZW50aWZpZXJz
IG9yIGJyb2tlbiByZWZlcmVuY2VzIFZGLVZTSSAqLw0KKwkJCWRldl93YXJuKCZwZi0+cGRldi0+
ZGV2LA0KKwkJCQkgIlNSSU9WIExBTiBWU0kgKGluZGV4ICVkIGluIFBGIFZTSSBhcnJheSkgd2l0
aCBpbnZhbGlkIFZGIElkZW50aWZpZXIgJWQgKHJlZmVyZW5jZWQgYnkgVkYgJWQsIG9yZGVyZWQg
YXMgJWQgaW4gVkYgYXJyYXkpXG4iLA0KKwkJCQkgdnNpX2lkeCwgcGYtPnZzaVt2c2lfaWR4XS0+
dmZfaWQsDQorCQkJCSBwZi0+dmZbdmZfaWR4XS52Zl9pZCwgdmZfaWR4KTsNCisJCQlpc192Zl92
YWxpZCA9IGZhbHNlOw0KKwkJfQ0KK2NoZWNrX3ZmOg0KKwkJaWYgKCFpc192Zl92YWxpZCkgew0K
KwkJCWk0MGVfYWRkX2V0aHRvb2xfc3RhdHMoJmRhdGEsIE5VTEwsDQorCQkJCQkgICAgICAgaTQw
ZV9nc3RyaW5nc19ldGhfc3RhdHNfZXh0cmEpOw0KKwkJfSBlbHNlIHsNCisJCQlpNDBlX3VwZGF0
ZV9ldGhfc3RhdHModnNpKTsNCisJCQlpNDBlX2FkZF9ldGh0b29sX3N0YXRzKCZkYXRhLCB2c2ks
DQorCQkJCQkgICAgICAgaTQwZV9nc3RyaW5nc19ldGhfc3RhdHNfZXh0cmEpOw0KKwkJfQ0KKwl9
DQorCWZvciAoOyB2Zl9pZCA8IEk0MEVfU1RBVFNfRVhUUkFfQ09VTlQ7IHZmX2lkKyspDQorCQlp
NDBlX2FkZF9ldGh0b29sX3N0YXRzKCZkYXRhLCBOVUxMLA0KKwkJCQkgICAgICAgaTQwZV9nc3Ry
aW5nc19ldGhfc3RhdHNfZXh0cmEpOw0KKw0KIGNoZWNrX2RhdGFfcG9pbnRlcjoNCiAJV0FSTl9P
TkNFKGRhdGEgLSBwICE9IGk0MGVfZ2V0X3N0YXRzX2NvdW50KG5ldGRldiksDQogCQkgICJldGh0
b29sIHN0YXRzIGNvdW50IG1pc21hdGNoISIpOw0KIH0NCiANCisvKioNCisgKiBfX2k0MGVfdXBk
YXRlX3ZmaWRfaW5fc3RhdHNfc3RyaW5ncyAtIHByaW50IFZGIG51bSB0byBzdGF0cyBuYW1lcw0K
KyAqIEBzdGF0c19leHRyYTogYXJyYXkgb2Ygc3RhdHMgc3RydWN0cyB3aXRoIHN0YXRzIG5hbWUg
c3RyaW5ncw0KKyAqIEBzdHJpbmdzX251bTogbnVtYmVyIG9mIHN0YXRzIG5hbWUgc3RyaW5ncyBp
biBhcnJheSBhYm92ZSAobGVuZ3RoKQ0KKyAqIEB2Zl9pZDogVkYgbnVtYmVyIHRvIHVwZGF0ZSBz
dGF0cyBuYW1lIHN0cmluZ3Mgd2l0aA0KKyAqDQorICogSGVscGVyIGZ1bmN0aW9uIHRvIGk0MGVf
Z2V0X3N0YXRfc3RyaW5ncygpIGluIGNhc2Ugb2YgZXh0cmEgc3RhdHMuDQorICoqLw0KK3N0YXRp
YyBpbmxpbmUgdm9pZA0KK19faTQwZV91cGRhdGVfdmZpZF9pbl9zdGF0c19zdHJpbmdzKHN0cnVj
dCBpNDBlX3N0YXRzIHN0YXRzX2V4dHJhW10sDQorCQkJCSAgICBpbnQgc3RyaW5nc19udW0sIGlu
dCB2Zl9pZCkNCit7DQorCWludCBpOw0KKw0KKwlmb3IgKGkgPSAwOyBpIDwgc3RyaW5nc19udW07
IGkrKykgew0KKwkJc25wcmludGYoc3RhdHNfZXh0cmFbaV0uc3RhdF9zdHJpbmcsDQorCQkJIEk0
MEVfU1RBVFNfTkFNRV9WRklEX0VYVFJBX0xFTiwgInZmJTAzZCIsIHZmX2lkKTsNCisJCXN0YXRz
X2V4dHJhW2ldLnN0YXRfc3RyaW5nW0k0MEVfU1RBVFNfTkFNRV9WRklEX0VYVFJBX0xFTiAtDQor
CQkJCQkJCQkgICAgICAgMV0gPSAnLic7DQorCX0NCit9DQorDQorLyoqDQorICogaTQwZV91cGRh
dGVfdmZpZF9pbl9zdGF0cyAtIHByaW50IFZGIG51bSB0byBzdGF0IG5hbWVzDQorICogQHN0YXRz
X2V4dHJhOiBhcnJheSBvZiBzdGF0cyBzdHJ1Y3RzIHdpdGggc3RhdHMgbmFtZSBzdHJpbmdzDQor
ICogQHZmX2lkOiBWRiBudW1iZXIgdG8gdXBkYXRlIHN0YXRzIG5hbWUgc3RyaW5ncyB3aXRoDQor
ICoNCisgKiBIZWxwZXIgbWFjcm8gdG8gaTQwZV9nZXRfc3RhdF9zdHJpbmdzKCkgdG8gZWFzZSB1
c2Ugb2YNCisgKiBfX2k0MGVfdXBkYXRlX3ZmaWRfaW5fc3RhdHNfc3RyaW5ncygpIGZ1bmN0aW9u
IGR1ZSB0byBleHRyYSBzdGF0cy4NCisgKg0KKyAqIE1hY3JvIHRvIGVhc2UgdGhlIHVzZSBvZiBf
X2k0MGVfdXBkYXRlX3ZmaWRfaW5fc3RhdHNfc3RyaW5ncyBieSANCit0YWtpbmcNCisgKiBhIHN0
YXRpYyBjb25zdGFudCBzdGF0cyBhcnJheSBhbmQgcGFzc2luZyB0aGUgQVJSQVlfU0laRSgpLiBU
aGlzIA0KK2F2b2lkcyB0eXBvcw0KKyAqIGJ5IGVuc3VyaW5nIHRoYXQgd2UgcGFzcyB0aGUgc2l6
ZSBhc3NvY2lhdGVkIHdpdGggdGhlIGdpdmVuIHN0YXRzIGFycmF5Lg0KKyAqDQorICogVGhlIHBh
cmFtZXRlciBAc3RhdHNfZXh0cmEgaXMgZXZhbHVhdGVkIHR3aWNlLCBzbyBwYXJhbWV0ZXJzIHdp
dGggDQorc2lkZQ0KKyAqIGVmZmVjdHMgc2hvdWxkIGJlIGF2b2lkZWQuDQorICoqLw0KKyNkZWZp
bmUgaTQwZV91cGRhdGVfdmZpZF9pbl9zdGF0cyhzdGF0c19leHRyYSwgdmZfaWQpIFwgDQorX19p
NDBlX3VwZGF0ZV92ZmlkX2luX3N0YXRzX3N0cmluZ3Moc3RhdHNfZXh0cmEsDQorQVJSQVlfU0la
RShzdGF0c19leHRyYSksIHZmX2lkKQ0KKw0KIC8qKg0KICAqIGk0MGVfZ2V0X3N0YXRfc3RyaW5n
cyAtIGNvcHkgc3RhdCBzdHJpbmdzIGludG8gc3VwcGxpZWQgYnVmZmVyDQogICogQG5ldGRldjog
dGhlIG5ldGRldiB0byBjb2xsZWN0IHN0cmluZ3MgZm9yIEBAIC0yMzU0LDYgKzI0OTgsMTEgQEAg
c3RhdGljIHZvaWQgaTQwZV9nZXRfc3RhdF9zdHJpbmdzKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRk
ZXYsIHU4ICpkYXRhKQ0KIAlmb3IgKGkgPSAwOyBpIDwgSTQwRV9NQVhfVVNFUl9QUklPUklUWTsg
aSsrKQ0KIAkJaTQwZV9hZGRfc3RhdF9zdHJpbmdzKCZkYXRhLCBpNDBlX2dzdHJpbmdzX3BmY19z
dGF0cywgaSk7DQogDQorCWZvciAoaSA9IDA7IGkgPCBJNDBFX1NUQVRTX0VYVFJBX0NPVU5UOyBp
KyspIHsNCisJCWk0MGVfdXBkYXRlX3ZmaWRfaW5fc3RhdHMoaTQwZV9nc3RyaW5nc19ldGhfc3Rh
dHNfZXh0cmEsIGkpOw0KKwkJaTQwZV9hZGRfc3RhdF9zdHJpbmdzKCZkYXRhLCBpNDBlX2dzdHJp
bmdzX2V0aF9zdGF0c19leHRyYSk7DQorCX0NCisNCiBjaGVja19kYXRhX3BvaW50ZXI6DQogCVdB
Uk5fT05DRShkYXRhIC0gcCAhPSBpNDBlX2dldF9zdGF0c19jb3VudChuZXRkZXYpICogRVRIX0dT
VFJJTkdfTEVOLA0KIAkJICAic3RhdCBzdHJpbmdzIGNvdW50IG1pc21hdGNoISIpOw0KLS0NCjIu
MjEuMA0KDQo=

--_002_35C27A066ED4844F952811E08E4D95090D398A32IRSMSX103gercor_--

